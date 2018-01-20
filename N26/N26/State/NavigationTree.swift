//
//  NavigationTree.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public enum NavigationTree {
    case realtime
    case historical

    static func root() -> NavigationTree {
        return .realtime
    }
}

extension NavigationTree: Equatable { }
