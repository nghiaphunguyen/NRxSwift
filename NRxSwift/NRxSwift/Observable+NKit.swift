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
    case Disposed
    case Completed
    case Error(ErrorType)
    case Next(T)
}

public extension Observable {
    public func nk_fullSubscribe(onResult: (result: NKRxResult<Element>) -> Void) -> Disposable {
        return self.subscribe(onNext: { (element) -> Void in
            onResult(result: NKRxResult.Next(element))
            }, onError: { (error) -> Void in
                onResult(result: NKRxResult.Error(error))
            }, onCompleted: { () -> Void in
                onResult(result: NKRxResult.Completed)
            }, onDisposed: { () -> Void in
                onResult(result: NKRxResult.Disposed)
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
    public static func nk_baseCreate(subscribe: NKBaseObserver<Element> -> Void) -> Observable<Element> {
        return Observable<Element>.create({ (observer) -> Disposable in
            let baseObserver = NKBaseObserver(anyObserver: observer)
            subscribe(baseObserver)
            return AnonymousDisposable {}
        })
    }
    
    public func nk_doOnNextOrError(closure: () -> Void) -> Observable<Element> {
        return self.doOnNext({ (_) in
            closure()
        }).self.doOnError({ (_) in
            closure()
        })
    }
    
    public static func nk_start(closure: () -> Observable<Element>) -> Observable<Element> {
        return Observable<Int>.just(0).flatMapLatest({ (element) -> Observable<Element> in
            return closure()
        })
    }
}

public extension Observable where Element : NKResult {
    public static func nk_create(subscribe: NKObserver -> Void) -> NKObservable {
        return NKObservable.create { (observer) -> Disposable in
            let nk_observer = NKObserverImpl(observer: observer) as NKObserver
            subscribe(nk_observer)
            return AnonymousDisposable {}
        }
    }
    
    public static func nk_error(error: ErrorType) -> NKObservable {
        return NKObservable.just(NKResult(error: error))
    }
    
    public static func nk_just(value: Any?) -> NKObservable {
        return NKObservable.just(NKResult(value: value))
    }
    
    public func nk_continueWithSuccessCloure(closure: (element: Element) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest { (element) -> Observable<Element> in
            let result = element as NKResult
            
            if let _ = result.error {
                return Observable.just(element)
            }
            
            return closure(element: element)
        }
    }
    
    public func nk_continueWithCloure(closure: (element: Element) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest { (element) -> Observable<Element> in
            return closure(element: element)
        }
    }
    
    public func nk_continueWithSuccessCloure<T>(closure: (value: T) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest { (element) -> Observable<Element> in
            let result = element as NKResult
            
            if let _ = result.error {
                return Observable.just(element)
            }
            
            return closure(value: element.value as! T)
        }
    }
    
    public func nk_continueWithCloure<T>(closure: (element: NKResultEnum<T>) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest { (element) -> Observable<Element> in
            return closure(element: element.toEnum())
        }
    }
    
    public func nk_doOnNext<T>(closure: (value: T) -> Void) -> Observable<Element> {
        return self.doOnNext { element in
            guard element.error == nil else {
                return
            }
            
            let value = element.value as! T
            closure(value: value)
        }
    }
    
    public func nk_doOnError(closure: (error: ErrorType) -> Void) -> Observable<Element> {
        return self.doOnNext { element in
            if let error = element.error {
                closure(error: error)
            }
        }
    }
    
    public func nk_transform<T>(type: T.Type? = nil) -> Observable<T> {
        return self.flatMapLatest { (element) -> Observable<T> in
            if let error = element.error {
                return Observable<T>.error(error)
            }
            
            return Observable<T>.just(element.value as! T)
        }
    }
    
    public func nk_transform<T>(type: T.Type? = nil) -> Observable<T?> {
        return self.flatMapLatest { (element) -> Observable<T?> in
            if let error = element.error {
                return Observable<T?>.error(error)
            }
            
            return Observable<T?>.just(element.value as? T)
        }
    }
    
    public func nk_subscribe<T>(closure: (element: NKResultEnum<T>) -> Void) -> Disposable {
        return self.subscribeNext({ (element) in
            closure(element: element.toEnum())
        })
    }
}