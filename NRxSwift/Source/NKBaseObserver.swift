//
//  NKBaseObserver.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 7/18/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

open class NKBaseObserver<T>: AnyObject {
    open let anyObserver: AnyObserver<T>

    public init(anyObserver: AnyObserver<T>) {
        self.anyObserver = anyObserver
    }

    open func nk_setValue(_ value: T) {
        self.anyObserver.onNext(value)
        self.anyObserver.onCompleted()
    }

    open func nk_setError(_ error: Error) {
        self.anyObserver.onError(error)
    }
}
