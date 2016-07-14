//
//  Observable+NKit.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 6/25/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

public extension Observable {
    public func nk_asNKObservable() -> NKObservable {
        return self.flatMapLatest({ (element) -> NKObservable in
            return NKObservable.nk_just(element)
        }).catchError({ (error) -> Observable<NKResult> in
          return NKObservable.nk_error(error)
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
    
    public func nk_transform<T>() -> Observable<T> {
        return self.flatMapLatest { (element) -> Observable<T> in
            if let error = element.error {
                return Observable<T>.error(error)
            }
            
            return Observable<T>.just(element.value as! T)
        }
    }
    
    public func nk_transform<T>() -> Observable<T?> {
        return self.flatMapLatest { (element) -> Observable<T?> in
            if let error = element.error {
                return Observable<T?>.error(error)
            }
            
            return Observable<T?>.just(element.value as? T)
        }
    }
}