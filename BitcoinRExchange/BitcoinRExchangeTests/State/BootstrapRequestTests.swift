@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import XCTest

class BootstrapRequestTests: UnitTest {
    let state = AppState()

    func testBootstrapRequestBoot() {
        var actions: [Action] = []
        var asyncActions: [AnyActionAsync<AppState>] = []
        let mockApplication = MockApplication()
        let mockWindow = MockWindow()

        BootstrapRequest
            .boot(application: mockApplication,
                  window: mockWindow,
                  launchOptions: [.bluetoothPeripherals: "Bluetooth1",
                                  .cloudKitShareMetadata: "CloudKit1"])
            .execute(getState: { [unowned self] in self.state },
                     dispatch: { actions.append($0) },
                     dispatchAsync: { asyncActions.append($0) })

        XCTAssertTrue(mockApplication.keepScreenOn)
        XCTAssertTrue(mockWindow.isKeyWindow)
        XCTAssertNotNil(mockWindow.rootViewController as? UINavigationController)
        let navigationController = mockWindow.rootViewController as! UINavigationController
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertNotNil(navigationController.viewControllers.first as? HistoricalViewController)

        XCTAssertEqual(actions.count, 1)
        self.assertAction(actions.first, shouldBeDidStart: mockApplication, navigationController: navigationController)
        XCTAssertEqual(asyncActions.count, 0)
    }

    private func assertAction(_ action: Action?, shouldBeDidStart application: Application, navigationController: UINavigationController) {
        let routerAction = action as? RouterAction
        XCTAssertNotNil(routerAction)
        if case let .didStart(app, nc) = routerAction! {
            XCTAssertTrue(app == application)
            XCTAssertEqual(nc, navigationController)
        } else {
            XCTFail("Wrong action triggered")
        }
    }
}
