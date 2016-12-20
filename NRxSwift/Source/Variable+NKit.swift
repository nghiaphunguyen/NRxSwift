//
//  Variable+NKit.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 6/25/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

public extension Variable {
    public func nk_asNKObservable() -> NKObservable {
        return self.asObservable().nk_asNKObservable()
    }
    
    public func nk_reload() {
        let val = self.value
        self.value = val
    }
    
    public var nk_variable: NKVariable<E> {
        return NKVariable(variable: self)
    }
}
