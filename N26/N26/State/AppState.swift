//
//  AppState.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit
import CommonLibrary

public struct AppState: Equatable {
    var bitcoinState = BitcoinState()
    var currency = Currency(code: "EUR", name: "Euro", symbol: "€")
    var historicalDays = 14

    var navigation = NavigationState.still(at: .root())
    weak var application: Application?
    weak var navigationController: UINavigationController?
}

extension AppState {
    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return
            lhs.bitcoinState == rhs.bitcoinState &&
            lhs.currency == rhs.currency &&
            lhs.historicalDays == rhs.historicalDays &&
            lhs.navigation == rhs.navigation
    }
}
