//
//  KnownRoute.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

public protocol KnownRoute {
    var route: NavigationRoute { get }
    func navigate(_ navigationController: UINavigationController, completion: @escaping () -> ())
}

public func ==(lhs: KnownRoute, rhs: KnownRoute) -> Bool {
    guard lhs.route == rhs.route else { return false }
    return true
}
