//
//  NKBaseObserver.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 7/18/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift

public class NKBaseObserver<T>: AnyObject {
    private let anyObserver: AnyObserver<T>
    
    init(anyObserver: AnyObserver<T>) {
        self.anyObserver = anyObserver
    }
    
    func nk_setValue(value: T) {
        self.anyObserver.onNext(value)
        self.anyObserver.onCompleted()
    }
    
    func nk_setError(error: ErrorType) {
        self.anyObserver.onError(error)
    }
}