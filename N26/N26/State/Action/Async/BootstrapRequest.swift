//
//  BootstrapRequest.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

enum BootstrapRequest: AppActionAsync {
    typealias StateType = AppState

    case boot(application: UIApplication, window: UIWindow, launchOptions: [UIApplicationLaunchOptionsKey: Any]?)

    func execute(getState: @escaping () -> AppState, dispatch: @escaping DispatchFunction) {
        switch self {
        case .boot(let application, let window, _):
            Theme.apply()
            UIApplication.shared.isIdleTimerDisabled = true

//            let navigationController = UINavigationController(rootViewController: MainViewController.start()!)
//            window.setup(with: navigationController)

//            dispatch(RouterAction.didStart(application, navigationController))
        }
    }
}
