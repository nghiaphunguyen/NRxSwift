//
//  NKVariable.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 12/20/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

public struct NKVariable<T> {
    private let observableClosure: () -> Observable<T>
    private let variableClosure: () -> T
    
    public init(observableClosure: @escaping () -> Observable<T>, variableClosure: @escaping () -> T) {
        self.observableClosure = observableClosure
        self.variableClosure = variableClosure
    }
    
    public init(variable: Variable<T>) {
        self.observableClosure = {
            return variable.asObservable()
        }
        
        self.variableClosure = {
            return variable.value
        }
    }
    
    public var value: T {
        return self.variableClosure()
    }
    
    public var observable: Observable<T> {
        return self.observableClosure()
    }
    
    public func map<S>(_ closure: @escaping (T) -> S) -> NKVariable<S> {
        
        return NKVariable<S>.init(observableClosure: {
            return self.observableClosure().map(closure)
        }, variableClosure: {
            return closure(self.variableClosure())
        })
    }
}
