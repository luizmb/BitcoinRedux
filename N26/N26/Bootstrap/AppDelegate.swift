//
//  AppDelegate.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 19.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    override init() {
        super.init()
        DefaultMapResolver.map()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.create()
        actionDispatcher.async(BootstrapRequest.boot(application: application,
                                                     window: window!,
                                                     launchOptions: launchOptions))
        return true
    }
}

extension AppDelegate: HasActionDispatcher { }