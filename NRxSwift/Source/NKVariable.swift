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
    private let variable: Variable<T>
    
    public init(variable: Variable<T>) {
        self.variable = variable
    }
    
    public var value: T {
        return self.variable.value
    }
    
    public var observable: Observable<T> {
        return self.variable.asObservable()
    }
}
