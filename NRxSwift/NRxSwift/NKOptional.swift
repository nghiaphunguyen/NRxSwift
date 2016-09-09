//
//  NKOptional.swift
//  NRxSwift
//
//  Created by Nghia Nguyen on 9/9/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public protocol NKOptional {
    associatedtype Wrapped
    var value: Wrapped? {get}
}

extension Optional: NKOptional {
    public var value: Wrapped? {
        return self
    }
}