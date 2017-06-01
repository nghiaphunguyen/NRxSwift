//
//  Observable+NKit.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 6/25/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

public enum NKRxResult<T> {
    case disposed
    case completed
    case error(Error)
    case next(T)
}

public extension Observable {
    public func nk_fullSubscribe(_ onResult: @escaping (_ result: NKRxResult<Element>) -> Void) -> Disposable {
        return self.subscribe(onNext: { (element) -> Void in
            onResult(NKRxResult.next(element))
            }, onError: { (error) -> Void in
                onResult(NKRxResult.error(error))
            }, onCompleted: { () -> Void in
                onResult(NKRxResult.completed)
            }, onDisposed: { () -> Void in
                onResult(NKRxResult.disposed)
        })
    }
}

public extension Observable {
    public func nk_asNKObservable() -> NKObservable {
        return self.flatMapLatest({ (element) -> NKObservable in
            return NKObservable.nk_just(element)
        }).catchError({ (error) -> Observable<NKResult> in
          return NKObservable.nk_error(error)
        })
    }
}

public extension Observable {
    public static func nk_baseCreate(_ subscribe: @escaping (NKBaseObserver<Element>) -> Void) -> Observable<Element> {
        return Observable<Element>.create({ (observer) -> Disposable in
            let baseObserver = NKBaseObserver(anyObserver: observer)
            subscribe(baseObserver)
            return Disposables.create {}
        })
    }
    
    public static func nk_start(_ closure: @escaping () -> Observable<Element>) -> Observable<Element> {
        return Observable<Int>.just(0).flatMapLatest({ (element) -> Observable<Element> in
            return closure()
        })
    }
    
    public func nk_subscribe(onNext: @escaping (Element) -> Void) -> Disposable {
        return self.nk_subscribe(onNext: onNext, onError: nil)
    }
    
    public func nk_subscribe(onNext: @escaping (Element) -> Void, onError: ((Error) -> Void)?) -> Disposable {
        return self.subscribe(onNext: onNext, onError: onError)
    }
    
    public func nk_debug(_ closure: @escaping (Element) -> Void) -> Observable<Element> {
        return self.map({
            closure($0)
            return $0
        })
    }
    
    public func nk_doOnNextOrError(_ closure: @escaping () -> Void) -> Observable<Element> {
        return self.do(onNext: { _ in
            closure()
        }, onError: { _ in
            closure()
        })
    }
    
    public func nk_doOnCompleteOrError(_ closure: @escaping () -> Void) -> Observable<Element> {
        return self.do(onError: { _ in
            closure()
        }, onCompleted: {
            closure()
        })
    }
    
    public func nk_doOnNextOrCompleteOrError(_ closure: @escaping () -> Void) -> Observable<Element> {
        return self.do(onNext: { _ in
            closure()
        }, onError: { _ in
            closure()
        }, onCompleted: {
            closure()
        })
    }
    
    public func nk_ignoreError() -> Observable<Element> {
        return self.catchError {_ in return Observable.empty()}
    }
}

public extension Observable where Element: NKOptional {
    public func nk_unwrap() -> Observable<Element.Wrapped> {
        return self.filter({$0.value != nil}).map {$0.value!}
    }
}

public extension Observable where Element : NKResult {
    public static func nk_create(_ subscribe: @escaping (NKObserver) -> Void) -> NKObservable {
        return NKObservable.create { (observer) -> Disposable in
            let nk_observer = NKObserverImpl(observer: observer) as NKObserver
            subscribe(nk_observer)
            return Disposables.create {}
        }
    }
    
    public static func nk_error(_ error: Error) -> NKObservable {
        return NKObservable.just(NKResult(value: error))
    }
    
    public static func nk_just(_ value: Any?) -> NKObservable {
        return NKObservable.just(NKResult(value: value))
    }
    
    public func nk_continueWithSuccessCloure(_ closure: @escaping (_ element: Element) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest { (element) -> Observable<Element> in
            let result = element as NKResult
            
            if let _ = result.error {
                return Observable.just(element)
            }
            
            return closure(element)
        }
    }
    
    public func nk_continueWithCloure(_ closure: @escaping (_ element: Element) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest { (element) -> Observable<Element> in
            return closure(element)
        }
    }
    
    public func nk_continueWithSuccessCloure<T>(_ closure: @escaping (_ value: T?) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest { (element) -> Observable<Element> in
            let result = element as NKResult
            
            if let _ = result.error {
                return Observable.just(element)
            }
            
            return closure(element.value as? T)
        }
    }
    
    public func nk_continueWithSuccessCloure<T>(_ closure: @escaping (_ value: T) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest { (element) -> Observable<Element> in
            let result = element as NKResult
            
            if let _ = result.error {
                return Observable.just(element)
            }
            
            return closure(element.value as! T)
        }
    }
    
    public func nk_continueWithCloure<T>(_ closure: @escaping (_ element: NKResultEnum<T>) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest { (element) -> Observable<Element> in
            return closure(element.toEnum())
        }
    }
    
    public func nk_doOnSuccess<T>(_ closure: @escaping (_ value: T?) -> Void) -> Observable<Element> {
        return self.do(onNext: {element in
            guard element.error == nil else {
                return
            }
            
            let value = element.value as? T
            closure(value)
        })
    }
    
    
    public func nk_doOnSuccess<T>(_ closure: @escaping (_ value: T) -> Void) -> Observable<Element> {
        return self.do(onNext: { element in
            guard element.error == nil else {
                return
            }
            
            let value = element.value as! T
            closure(value)
        })
    }
    
    public func nk_doOnError(_ closure: @escaping (_ error: Error) -> Void) -> Observable<Element> {
        return self.do(onNext: { element in
            if let error = element.error {
                closure(error)
            }
        })
    }
    
    public func nk_transform<T>(_ type: T.Type? = nil) -> Observable<T> {
        return self.flatMapLatest { (element) -> Observable<T> in
            if let error = element.error {
                return Observable<T>.error(error)
            }
            
            return Observable<T>.just(element.value as! T)
        }
    }
    
    public func nk_transform<T>(_ type: T.Type? = nil) -> Observable<T?> {
        return self.flatMapLatest { (element) -> Observable<T?> in
            if let error = element.error {
                return Observable<T?>.error(error)
            }
            
            return Observable<T?>.just(element.value as? T)
        }
    }
    
    public func nk_subscribe<T>(_ closure: @escaping (_ element: NKResultEnum<T>) -> Void) -> Disposable {
        return self.subscribe(onNext: { (element) in
            closure(element.toEnum())
        })
    }
    
    public func nk_subscribe<T>(_ closure: @escaping (_ element: NKResultEnum<T?>) -> Void) -> Disposable {
        return self.subscribe(onNext: { (element) in
            closure(element.toEnum2())
        })
    }
}

public extension Observable {
    public static func nk_from<T>(_ function: @escaping () -> T) -> Observable<T> {
        return Observable<T>.nk_baseCreate({ (observer) in
            observer.nk_setValue(function())
        })
    }
    
    public static func nk_from<T, A>(_ a: A, _ function: @escaping (A) -> T) -> Observable<T> {
        return Observable<T>.nk_baseCreate({ (observer) in
            observer.nk_setValue(function(a))
        })
    }
    
    public static func nk_from<T, A, B>(_ a: A, b: B, _ function: @escaping (A, B) -> T) -> Observable<T> {
        return Observable<T>.nk_baseCreate({ (observer) in
            observer.nk_setValue(function(a, b))
        })
    }
    
    public static func nk_from<T, A, B, C>(_ a: A, _ b: B, _ c: C, _ function: @escaping (A, B, C) -> T) -> Observable<T> {
        return Observable<T>.nk_baseCreate({ (observer) in
            observer.nk_setValue(function(a, b ,c))
        })
    }
    
    public static func nk_from<T, A, B, C ,D>(_ a: A, _ b: B, _ c: C, _ d: D, _ function: @escaping (A, B, C, D) -> T) -> Observable<T> {
        return Observable<T>.nk_baseCreate({ (observer) in
            observer.nk_setValue(function(a, b, c, d))
        })
    }
    
    public static func nk_from<T, A, B, C, D, E>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ function: @escaping (A, B, C, D, E) -> T) -> Observable<T> {
        return Observable<T>.nk_baseCreate({ (observer) in
            observer.nk_setValue(function(a, b, c, d, e))
        })
    }
    
    public static func nk_from<T, A, B, C, D, E, F>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ function: @escaping (A, B, C, D, E, F) -> T) -> Observable<T> {
        return Observable<T>.nk_baseCreate({ (observer) in
            observer.nk_setValue(function(a, b, c, d, e, f))
        })
    }
    
    public func nk_observeOnMainQueue() -> Observable<Element> {
        return self.observeOn(MainScheduler.instance)
    }
    
    public func nk_observeAsyncOnMainQueue() -> Observable<Element> {
        return self.observeOn(MainScheduler.asyncInstance)
    }
    
    public func nk_observeOnQueue(queue: DispatchQueue) -> Observable<Element> {
        return self.flatMapLatest({ element in
            return Observable<Element>.nk_baseCreate({ (observer) in
                queue.async {
                    observer.nk_setValue(element)
                }
            })
        })
    }
}
