//
//  BootstrapRequest.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit
import BitcoinLibrary
import CommonLibrary

enum BootstrapRequest: AppActionAsync {
    typealias StateType = AppState

    case boot(application: Application, window: Window, launchOptions: [UIApplicationLaunchOptionsKey: Any]?)

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> ()) {
        switch self {
        case .boot(let application, let window, _):
            Theme.apply()
            application.keepScreenOn = true

            let navigationController = UINavigationController(rootViewController: HistoricalViewController.start()!)
            window.setup(with: navigationController)

            dispatch(RouterAction.didStart(application, navigationController))

            // TODO: Trigger auto-refresh
            dispatchAsync(AnyActionAsync(BitcoinRateRequest.realtimeCache))
            dispatchAsync(AnyActionAsync(BitcoinRateRequest.historicalCache))
            dispatchAsync(AnyActionAsync(BitcoinRateRequest.realtimeRefresh))
            dispatchAsync(AnyActionAsync(BitcoinRateRequest.historicalDataRefresh))
        }
    }
}
