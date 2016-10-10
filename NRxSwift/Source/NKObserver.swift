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
    func nk_setValue(_ value: Any?)
    func nk_setError(_ error: Error)
}

open class NKObserverImpl: NKObserver {
    
    fileprivate var observer: AnyObserver<NKResult>?
    
    init(observer: AnyObserver<NKResult>) {
        self.observer = observer
    }
    
    open func nk_setValue(_ value: Any?) {
        self.observer?.nk_setValue(value)
    }
    
    open func nk_setError(_ error: Error) {
        self.observer?.nk_setError(error)
    }
}
