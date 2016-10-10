//
//  NKResult.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 6/25/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

import Foundation
import RxSwift

public typealias NKObservable = Observable<NKResult>

public enum NKResultEnum<T> {
    case value(T)
    case error(Error)
}

open class NKResult: AnyObject {
    
    open fileprivate(set) var value: Any? {
        didSet {
            self.type = type(of: self.value)
        }
    }
    open fileprivate(set) var type: Any.Type?
    open fileprivate(set) var error: Error?
    
    open static var Empty: NKResult {
        return NKResult()
    }
    
    public init() {}
    
    public init(value: Any?) {
        self.value = value
    }
    
    public init(error: Error) {
        self.error = error
    }
    
    open func toEnum<T>() -> NKResultEnum<T> {
        if let error = self.error {
            return NKResultEnum.error(error)
        }
        
        let value = self.value as! T
        return NKResultEnum.value(value)
    }
    
    open func toEnum2<T>() -> NKResultEnum<T?> {
        if let error = self.error {
            return NKResultEnum.error(error)
        }
        
        let value = self.value as? T
        return NKResultEnum.value(value)
    }
}
