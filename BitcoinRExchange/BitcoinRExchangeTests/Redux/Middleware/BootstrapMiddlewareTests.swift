@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import RxBlocking
import RxSwift
import RxTest
import SwiftRex
import XCTest

class BootstrapMiddlewareTests: UnitTest {
    func testBootstrapRequestBoot() {
        let mockApplication = MockApplication()
        let mockWindow = MockWindow()
        let actionHandler = MockActionHandler()
        let state = ApplicationState()
        let nextShouldBeCalled = expectation(description: "next should be called")
        let bitcoinShouldBeSetup = expectation(description: "bitcoin setup should be called")
        let event = ApplicationEvent.boot(application: mockApplication,
                                          window: mockWindow,
                                          launchOptions: [.bluetoothPeripherals: "Bluetooth1",
                                                          .cloudKitShareMetadata: "CloudKit1"])
        let next = { (e: EventProtocol, getState: () -> ApplicationState) in
            XCTAssertEqual(state, getState())
            if let applicationEvent = e as? ApplicationEvent,
                case let .boot(sentApplication, sentWindow, sentLaunchOptions) = applicationEvent {
                XCTAssert(sentApplication === mockApplication)
                XCTAssert(mockWindow === sentWindow)
                XCTAssertEqual(sentLaunchOptions![.bluetoothPeripherals] as! String, "Bluetooth1")
                nextShouldBeCalled.fulfill()
            } else if let bitcoinEvent = e as? BitcoinRateEvent,
                case .setup = bitcoinEvent {
                bitcoinShouldBeSetup.fulfill()
            } else {
                XCTFail("Invalid event")
            }
        }

        let sut = BootstrapMiddleware()
        sut.actionHandler = actionHandler
        sut.handle(event: event, getState: { state }, next: next)

        XCTAssertTrue(mockApplication.keepScreenOn)
        XCTAssertTrue(mockWindow.isKeyWindow)
        XCTAssertNotNil(mockWindow.rootViewController as? UINavigationController)
        let navigationController = mockWindow.rootViewController as! UINavigationController
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertNotNil(navigationController.viewControllers.first as? HistoricalViewController)

        XCTAssertEqual(actionHandler.actions.count, 1)
        assertAction(actionHandler.actions.first,
                     shouldBeDidStart: (application: mockApplication, navigationController: navigationController))
        wait(for: [nextShouldBeCalled, bitcoinShouldBeSetup], timeout: 1)
    }
}

private func assertAction(_ action: ActionProtocol?,
                          shouldBeDidStart params: (application: Application, navigationController: UINavigationController)) {
    let routerAction = action as? RouterAction
    XCTAssertNotNil(routerAction)
    if case let .didStart(app, nc) = routerAction! {
        XCTAssertTrue(app == params.application)
        XCTAssertEqual(nc, params.navigationController)
    } else {
        XCTFail("Wrong action triggered")
    }
}
