//
//  Startable.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

public protocol Startable {
    static func start() -> Self?
}

#if os(iOS)
extension Startable where Self: UIViewController {
    public static func start() -> Self? {
        return Self(nibName: nibName, bundle: nil)
    }
}
#endif
