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
    case Value(T)
    case Error(ErrorType)
}

public class NKResult: AnyObject {
    
    public private(set) var value: Any? {
        didSet {
            self.type = self.value.dynamicType.self
        }
    }
    public private(set) var type: Any.Type?
    public private(set) var error: ErrorType?
    
    public static var Empty: NKResult {
        return NKResult()
    }
    
    public init() {}
    
    public init(value: Any?) {
        self.value = value
    }
    
    public init(error: ErrorType) {
        self.error = error
    }
    
    public func toEnum<T>() -> NKResultEnum<T> {
        if let error = self.error {
            return NKResultEnum.Error(error)
        }
        
        let value = self.value as! T
        return NKResultEnum.Value(value)
    }
}
