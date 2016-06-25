//
//  NKObserver.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 6/25/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

public protocol NKObserver {
    func nk_setValue(value: Any?)
    func nk_setError(error: ErrorType)
}

public class NKObserverImpl: NKObserver {
    
    private var observer: AnyObserver<NKResult>?
    
    init(observer: AnyObserver<NKResult>) {
        self.observer = observer
    }
    
    public func nk_setValue(value: Any?) {
        self.observer?.nk_setValue(value)
    }
    
    public func nk_setError(error: ErrorType) {
        self.observer?.nk_setError(error)
    }
}