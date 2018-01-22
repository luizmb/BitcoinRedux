//
//  AppDelegate.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 19.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit
import BitcoinLibrary
import CommonLibrary

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var refreshTimer: Timer?

    override init() {
        super.init()
        DefaultMapResolver.map()
    }

    @objc func refresh() {
        actionDispatcher.async(BitcoinRateRequest.realtimeRefresh(isManual: false))
        actionDispatcher.async(BitcoinRateRequest.historicalDataRefresh(isManual: false))
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.create() as? UIWindow
        actionDispatcher.async(BootstrapRequest.boot(application: application, window: window!, launchOptions: launchOptions))
        actionDispatcher.async(BitcoinRateRequest.realtimeCache)
        actionDispatcher.async(BitcoinRateRequest.historicalCache)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        refreshTimer = Timer.scheduledTimer(timeInterval: 30,
                                            target: self,
                                            selector: #selector(refresh),
                                            userInfo: nil,
                                            repeats: true)
        refreshTimer?.fire()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        refreshTimer?.invalidate()
    }
}

extension AppDelegate: HasActionDispatcher { }
