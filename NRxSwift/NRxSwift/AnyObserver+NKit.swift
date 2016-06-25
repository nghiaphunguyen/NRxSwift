//
//  AnyObserver+NKit.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 6/25/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

public extension AnyObserver where Element : NKResult {
    public func nk_setValue(value: Any?) {
        let value = NKResult(value: value) as! Element
        self.onNext(value)
        self.onCompleted()
    }
    
    public func nk_setError(error: ErrorType) {
        let errorResult = NKResult(error: error) as! Element
        self.onNext(errorResult)
        self.onCompleted()
    }
}