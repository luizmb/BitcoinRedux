@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import XCTest

class AppDelegateTests: UnitTest {

    func testApplicationLaunchedExpectedActions() {
        let sut = AppDelegate()

        let actionDispatcher = MockActionDispatcher()
        injector.mapper.mapSingleton(ActionDispatcher.self) { actionDispatcher }

        let result = sut.application(UIApplication.shared,
                                     didFinishLaunchingWithOptions: [.bluetoothPeripherals: "Bluetooth1",
                                                                     .cloudKitShareMetadata: "CloudKit1"])

        let expectedApplication: Application = UIApplication.shared
        let expectedWindow: Window = UIApplication.shared.windows.first!

        XCTAssertEqual(actionDispatcher.actions.count, 0)
        XCTAssertEqual(actionDispatcher.asyncActions.count, 3)
        let bootstrapRequest = actionDispatcher.asyncActions.first as? BootstrapRequest
        XCTAssertNotNil(bootstrapRequest)
        guard case let .boot(app, window, options) = bootstrapRequest! else {
            XCTFail("Invalid action request")
            return
        }
        XCTAssertTrue(app == expectedApplication)
        XCTAssertTrue(window == expectedWindow)

        let realtimeCacheRequest = actionDispatcher.asyncActions[1] as? BitcoinRateRequest
        XCTAssertNotNil(realtimeCacheRequest)
        guard case .realtimeCache = realtimeCacheRequest! else {
            XCTFail("Invalid action request")
            return
        }

        let historicalCacheRequest = actionDispatcher.asyncActions[2] as? BitcoinRateRequest
        XCTAssertNotNil(historicalCacheRequest)
        guard case .historicalCache = historicalCacheRequest! else {
            XCTFail("Invalid action request")
            return
        }

        let expectedOptions = [UIApplicationLaunchOptionsKey.bluetoothPeripherals: "Bluetooth1" as Any,
                               UIApplicationLaunchOptionsKey.cloudKitShareMetadata: "CloudKit1" as Any] as [UIApplicationLaunchOptionsKey: Any]?
        XCTAssertTrue(options?.keys == expectedOptions?.keys)
        XCTAssertTrue(result)
    }
}
