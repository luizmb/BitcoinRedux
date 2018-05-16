import XCTest
import Foundation
@testable import BitcoinRExchange
@testable import BitcoinLibrary
@testable import CommonLibrary

class NavigationActionRequestTests: UnitTest {
    let navigationController = UINavigationController()
    var state = AppState()

    override func setUp() {
        super.setUp()
        state.navigationController = navigationController
    }

    func testNavigationRequestNavigate() {
        var actions: [Action] = []
        var asyncActions: [AnyActionAsync<AppState>] = []
        let mockRoute = MockRoute()
        mockRoute.onCallNavigate = { [unowned self, unowned mockRoute] _, completion in
            XCTAssertEqual(actions.count, 1)
            XCTAssertEqual(asyncActions.count, 0)
            self.assertAction(actions.first, shouldBeWillNavigateToRoute: mockRoute.route)
        }

        NavigationActionRequest
            .navigate(route: mockRoute)
            .execute(getState: { [unowned self] in self.state },
                     dispatch: { actions.append($0) },
                     dispatchAsync: { asyncActions.append($0) })

        mockRoute.calledNavigate?.1()
        XCTAssertEqual(actions.count, 2)
        XCTAssertEqual(asyncActions.count, 0)
        self.assertAction(actions.first, shouldBeWillNavigateToRoute: mockRoute.route)
        self.assertAction(actions[1], shouldBeDidNavigateToDestination: mockRoute.route.destination)
    }

    func testNavigationRequestNavigateWithoutNavigationController() {
        state.navigationController = nil

        var actions: [Action] = []
        var asyncActions: [AnyActionAsync<AppState>] = []
        let mockRoute = MockRoute()
        mockRoute.onCallNavigate = { _, _ in
            XCTFail("Should not call navigate")
        }

        NavigationActionRequest
            .navigate(route: mockRoute)
            .execute(getState: { [unowned self] in self.state },
                     dispatch: { actions.append($0) },
                     dispatchAsync: { asyncActions.append($0) })

        XCTAssertNil(mockRoute.calledNavigate)
        XCTAssertEqual(actions.count, 0)
        XCTAssertEqual(asyncActions.count, 0)
    }

    private func assertAction(_ action: Action?, shouldBeWillNavigateToRoute route: NavigationRoute) {
        let routerAction = action as? RouterAction
        XCTAssertNotNil(routerAction)
        if case let .willNavigate(r) = routerAction! {
            XCTAssertEqual(r, route)
        } else {
            XCTFail("Wrong action triggered")
        }
    }

    private func assertAction(_ action: Action?, shouldBeDidNavigateToDestination destination: NavigationTree) {
        let routerAction = action as? RouterAction
        XCTAssertNotNil(routerAction)
        if case let .didNavigate(dest) = routerAction! {
            XCTAssertEqual(dest, destination)
        } else {
            XCTFail("Wrong action triggered")
        }
    }
}

