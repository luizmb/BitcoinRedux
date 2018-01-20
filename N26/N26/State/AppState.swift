//
//  AppState.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

public struct AppState: Equatable {
    var navigation = NavigationState.still(at: .root())
    weak var application: UIApplication?
    weak var navigationController: UINavigationController?
}

extension AppState {
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.navigation == rhs.navigation
    }
}
