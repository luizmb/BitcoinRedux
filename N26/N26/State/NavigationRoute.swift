//
//  NavigationRoute.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public struct NavigationRoute {
    let origin: NavigationTree
    let destination: NavigationTree
}

extension NavigationRoute: Equatable {
    public static func ==(lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        return lhs.origin == rhs.origin && lhs.destination == rhs.destination
    }
}
