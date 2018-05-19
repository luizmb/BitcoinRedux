@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import RxBlocking
import RxSwift
import RxTest
import SwiftRex
import XCTest

class NavigationMiddlewareTests: UnitTest {
    let mockAPIResponse = MockAPIResponse()
    let navigationController = UINavigationController()
    var state = GlobalState()

    override func setUp() {
        super.setUp()
//        injector.mapper.mapSingleton(BitcoinRateAPI.self) { return self.mockAPIResponse }
//        injector.mapper.mapSingleton(RepositoryProtocol.self) { return MockRepository() }

        state.applicationState.navigationController = navigationController
    }

    func testNavigationRequestNavigate() {
        let mockRoute = MockRoute()
        let source = UIViewController()
        let actionHandler = MockActionHandler()
        var state = ApplicationState()
        let navigationController = UINavigationController()
        state.navigationController = navigationController
        let nextShouldBeCalled = expectation(description: "next should be called")
        let event = RouterEvent.navigateRequest(viewController: source, route: mockRoute)
        mockRoute.onCallNavigate = { [unowned self, unowned mockRoute] _, completion in
            XCTAssertEqual(actionHandler.actions.count, 1)
            self.assertAction(actionHandler.actions.first, shouldBeWillNavigateToRoute: mockRoute.route)
        }
        let next = { (e: EventProtocol, getState: () -> ApplicationState) in
            XCTAssertEqual(state, getState())
            guard let routerEvent = e as? RouterEvent,
                case let .navigateRequest(viewController, route) = routerEvent else {
                    XCTFail("Invalid event chaining")
                    return
            }
            XCTAssert(source === viewController)
            XCTAssert((route as! MockRoute) === mockRoute)
            nextShouldBeCalled.fulfill()
        }

        let sut = NavigationMiddleware()
        sut.actionHandler = actionHandler
        sut.handle(event: event, getState: { state }, next: next)

        mockRoute.calledNavigate?.1()
        XCTAssertEqual(actionHandler.actions.count, 1)
        self.assertAction(actionHandler.actions.first, shouldBeWillNavigateToRoute: mockRoute.route)
//        self.assertAction(actionHandler.actions[1], shouldBeDidNavigateToDestination: mockRoute.route.destination)
    }

    private func assertAction(_ action: ActionProtocol?, shouldBeWillNavigateToRoute route: NavigationRoute) {
        let routerAction = action as? RouterAction
        XCTAssertNotNil(routerAction)
        if case let .navigationStarted(_, r) = routerAction! {
            XCTAssertEqual(r, route)
        } else {
            XCTFail("Wrong action triggered")
        }
    }

    private func assertAction(_ action: ActionProtocol?, shouldBeDidNavigateToDestination destination: NavigationTree) {
        let routerAction = action as? RouterAction
        XCTAssertNotNil(routerAction)
        if case let .didNavigate(dest) = routerAction! {
            XCTAssertEqual(dest, destination)
        } else {
            XCTFail("Wrong action triggered")
        }
    }
}
