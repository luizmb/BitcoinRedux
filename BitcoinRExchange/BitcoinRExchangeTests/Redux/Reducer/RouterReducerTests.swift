@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
@testable import SwiftRex
import XCTest

class RouterReducerTests: UnitTest {
    let globalState = GlobalState()
    let sut = routerReducer.lift(\GlobalState.applicationState)

    func testRouterReducerFoo() {
        let newState = sut.reduce(globalState, FooAction.foo)
        XCTAssertEqual(globalState, newState)
    }

    func tesRouterReducerDidStart() {
        let nc = UINavigationController()
        let mockApplication = MockApplication()
        let newState = sut.reduce(globalState, RouterAction.didStart(mockApplication, nc))
        XCTAssertNotEqual(globalState, newState)
        XCTAssertFalse(globalState.applicationState.application! == newState.applicationState.application!)
        XCTAssertEqual(globalState.bitcoinState, newState.bitcoinState)
        XCTAssertEqual(globalState.applicationState.navigation, newState.applicationState.navigation)
        XCTAssertNotEqual(globalState.applicationState.navigationController, newState.applicationState.navigationController)
        XCTAssertTrue(newState.applicationState.application! == mockApplication)
        XCTAssertEqual(newState.applicationState.navigationController, nc)
        XCTAssertEqual(newState.applicationState.navigation, .still(at: .listHistoricalAndRealtime))
    }

    func tesRouterReducerWillNavigate() {
        let vc = UIViewController()
        let newState = sut.reduce(globalState, RouterAction.navigationStarted(source: vc, route: .mock))
        XCTAssertNotEqual(globalState, newState)
        XCTAssertNotEqual(globalState.applicationState.navigation, newState.applicationState.navigation)
        XCTAssertNil(globalState.applicationState.application)
        XCTAssertNil(newState.applicationState.application)
        XCTAssertEqual(globalState.bitcoinState, newState.bitcoinState)
        XCTAssertEqual(globalState.applicationState.navigationController, newState.applicationState.navigationController)
        XCTAssertEqual(newState.applicationState.navigation, .navigating(.mock))
    }

    func testRouterReducerDidNavigate() {
        let newState = sut.reduce(globalState, RouterAction.didNavigate(.root()))
        XCTAssertEqual(globalState, newState)

        XCTAssertEqual(globalState.applicationState.navigation, .still(at: .root()))
        let vc = UIViewController()
        let navigatingState = sut.reduce(globalState, RouterAction.navigationStarted(source: vc, route: .mock))
        XCTAssertEqual(navigatingState.applicationState.navigation, .navigating(.mock))
        let navigationEndedState = sut.reduce(navigatingState, RouterAction.didNavigate(.root()))
        XCTAssertEqual(navigationEndedState.applicationState.navigation, .still(at: .root()))
    }
}
