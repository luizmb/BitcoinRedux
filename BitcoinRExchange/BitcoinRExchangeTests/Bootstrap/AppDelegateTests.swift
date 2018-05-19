@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import SwiftRex
import XCTest

class AppDelegateTests: UnitTest {

    func testApplicationLaunchedExpectedActions() {
        let sut = AppDelegate()

        let eventHandler = MockEventHandler()
        injector.mapper.mapSingleton(EventHandler.self) { eventHandler }

        let result = sut.application(UIApplication.shared,
                                     didFinishLaunchingWithOptions: [.bluetoothPeripherals: "Bluetooth1",
                                                                     .cloudKitShareMetadata: "CloudKit1"])

        let expectedApplication: Application = UIApplication.shared
        let expectedWindow: Window = UIApplication.shared.windows.first!

        XCTAssertEqual(eventHandler.events.count, 1)
        let applicationEvent = eventHandler.events.first as? ApplicationEvent
        XCTAssertNotNil(applicationEvent)
        guard case let .boot(app, window, options) = applicationEvent! else {
            XCTFail("Invalid action request")
            return
        }
        XCTAssertTrue(app == expectedApplication)
        XCTAssertTrue(window == expectedWindow)

        let expectedOptions = [UIApplicationLaunchOptionsKey.bluetoothPeripherals: "Bluetooth1" as Any,
                               UIApplicationLaunchOptionsKey.cloudKitShareMetadata: "CloudKit1" as Any] as [UIApplicationLaunchOptionsKey: Any]?
        XCTAssertTrue(options?.keys == expectedOptions?.keys)
        XCTAssertTrue(result)
    }
}
