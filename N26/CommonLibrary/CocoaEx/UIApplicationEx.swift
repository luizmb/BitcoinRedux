//
//  UIApplicationEx.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

@objc public protocol Application: class, NSObjectProtocol {
    var keepScreenOn: Bool { get set }
    @objc var hashValue: Int { get }
}

public func ==(lhs: Application, rhs: Application) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

extension UIApplication: Application {
    public var keepScreenOn: Bool {
        get {
            return self.isIdleTimerDisabled
        }
        set {
            self.isIdleTimerDisabled = newValue
        }
    }
}