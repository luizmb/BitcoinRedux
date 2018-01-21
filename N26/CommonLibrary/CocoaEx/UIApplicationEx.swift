//
//  UIApplicationEx.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

@objc public protocol Application: class, NSObjectProtocol {
    var keepScreenOn: Bool { get set }
    @objc var hashValue: Int { get }
}

public func ==(lhs: Application, rhs: Application) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

#if os(iOS)
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
#endif
