//
//  RouterReducerTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26
@testable import CommonLibrary

class RouterReducerTests: UnitTest {
    let appState = AppState()
    let reducer = RouterReducer()

    func testRouterReducerFoo() {
        let newState = reducer.reduce(appState, action: FooAction.foo)
        XCTAssertEqual(appState, newState)
    }

    func tesRouterReducerDidStart() {
        let nc = UINavigationController()
        let mockApplication = MockApplication()
        let newState = reducer.reduce(appState, action: RouterAction.didStart(mockApplication, nc))
        XCTAssertNotEqual(appState, newState)
        XCTAssertFalse(appState.application! == newState.application!)
        XCTAssertEqual(appState.bitcoinState, newState.bitcoinState)
        XCTAssertEqual(appState.navigation, newState.navigation)
        XCTAssertNotEqual(appState.navigationController, newState.navigationController)
        XCTAssertTrue(newState.application! == mockApplication)
        XCTAssertEqual(newState.navigationController, nc)
        XCTAssertEqual(newState.navigation, .still(at: .listHistoricalAndRealtime))
    }

    func tesRouterReducerWillNavigate() {
        let newState = reducer.reduce(appState, action: RouterAction.willNavigate(.mock))
        XCTAssertNotEqual(appState, newState)
        XCTAssertNotEqual(appState.navigation, newState.navigation)
        XCTAssertNil(appState.application)
        XCTAssertNil(newState.application)
        XCTAssertEqual(appState.bitcoinState, newState.bitcoinState)
        XCTAssertEqual(appState.navigationController, newState.navigationController)
        XCTAssertEqual(newState.navigation, .navigating(.mock))
    }

    func testRouterReducerDidNavigate() {
        let newState = reducer.reduce(appState, action: RouterAction.didNavigate(.root()))
        XCTAssertEqual(appState, newState)

        XCTAssertEqual(appState.navigation, .still(at: .root()))
        let navigatingState = reducer.reduce(appState, action: RouterAction.willNavigate(.mock))
        XCTAssertEqual(navigatingState.navigation, .navigating(.mock))
        let navigationEndedState = reducer.reduce(navigatingState, action: RouterAction.didNavigate(.root()))
        XCTAssertEqual(navigationEndedState.navigation, .still(at: .root()))
    }
}
