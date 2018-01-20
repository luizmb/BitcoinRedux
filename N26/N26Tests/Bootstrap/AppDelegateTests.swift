//
//  AppDelegateTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26

class AppDelegateTests: UnitTest {

    override func setUp() {
        super.setUp()
    }

    func testApplicationLaunchedExpectedActions() {
        let sut = AppDelegate()

        let actionDispatcher = MockActionDispatcher()
        injector.mapper.mapSingleton(ActionDispatcher.self) { actionDispatcher }

        let result = sut.application(UIApplication.shared,
                                     didFinishLaunchingWithOptions: [.bluetoothPeripherals: "Bluetooth1",
                                                                     .cloudKitShareMetadata: "CloudKit1"])

        XCTAssertEqual(actionDispatcher.actions.count, 0)
        XCTAssertEqual(actionDispatcher.asyncActions.count, 1)
        let actionTriggered = actionDispatcher.asyncActions.first as? BootstrapRequest
        XCTAssertNotNil(actionTriggered)
        guard case let .boot(app, window, options) = actionTriggered! else {
            XCTFail("Invalid action request")
            return
        }
        XCTAssertEqual(app, UIApplication.shared)
        XCTAssertEqual(window, UIApplication.shared.windows.first)
        let expectedOptions = [UIApplicationLaunchOptionsKey.bluetoothPeripherals: "Bluetooth1" as Any,
                               UIApplicationLaunchOptionsKey.cloudKitShareMetadata: "CloudKit1" as Any] as [UIApplicationLaunchOptionsKey: Any]?
        XCTAssertTrue(options?.keys == expectedOptions?.keys)
        XCTAssertTrue(result)
    }
}
