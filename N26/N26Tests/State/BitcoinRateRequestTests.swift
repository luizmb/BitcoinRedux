//
//  BitcoinRateRequestTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26

class BitcoinRateRequestTests: UnitTest {

    func testBootstrapRequestRealTime() {
        var state = AppState()
        let oldTask = Cancelable(), newTask = Cancelable()
        state.bitcoinState.realtimeRate = .syncing(task: oldTask, oldValue: nil)
        var actions: [Action] = []
        var asyncActions: [AnyActionAsync<AppState>] = []
        let mockAPI = MockAPI()
        mockAPI.onCallRequest = { endpoint, completion in
            XCTAssertEqual(actions.count, 0)
            XCTAssertEqual(asyncActions.count, 0)
            XCTAssertEqual(endpoint.urlRequest.url?.absoluteString, "https://api.coindesk.com/v1/bpi/currentprice/EUR.json")
            return newTask
        }
        injector.mapper.mapSingleton(BitcoinRateAPI.self) { mockAPI }

        BitcoinRateRequest
            .realtimeRefresh
            .execute(getState: { state },
                     dispatch: { actions.append($0) },
                     dispatchAsync: { asyncActions.append($0) })

        XCTAssertEqual(oldTask.cancelCount, 1)
        XCTAssertEqual(actions.count, 1)
        assertAction(actions.first, shouldBeWillRefreshRealTime: newTask)
        mockAPI.calledRequest?.1(.error(AnyError()))

        XCTAssertEqual(actions.count, 2)
        assertAction(actions.first, shouldBeWillRefreshRealTime: newTask)
        assertAction(actions[1], shouldBeDidRefreshRealTime: .error(AnyError()))
    }

    func testBootstrapRequestHistoricalData() {
        var state = AppState()
        let oldTask = Cancelable(), newTask = Cancelable()
        state.bitcoinState.historicalRates = .syncing(task: oldTask, oldValue: nil)
        var actions: [Action] = []
        var asyncActions: [AnyActionAsync<AppState>] = []
        let mockAPI = MockAPI()
        mockAPI.onCallRequest = { endpoint, completion in
            XCTAssertEqual(actions.count, 0)
            XCTAssertEqual(asyncActions.count, 0)
            XCTAssertTrue(endpoint.urlRequest.url?.absoluteString.starts(with: "https://api.coindesk.com/v1/bpi/historical/close.json?") ?? false)
            return newTask
        }
        injector.mapper.mapSingleton(BitcoinRateAPI.self) { mockAPI }

        BitcoinRateRequest
            .historicalDataRefresh
            .execute(getState: { state },
                     dispatch: { actions.append($0) },
                     dispatchAsync: { asyncActions.append($0) })

        XCTAssertEqual(oldTask.cancelCount, 1)
        XCTAssertEqual(actions.count, 1)
        assertAction(actions.first, shouldBeWillRefreshHistoricalData: newTask)
        mockAPI.calledRequest?.1(.error(AnyError()))

        XCTAssertEqual(actions.count, 2)
        assertAction(actions.first, shouldBeWillRefreshHistoricalData: newTask)
        assertAction(actions[1], shouldBeDidRefreshHistoricalData: .error(AnyError()))
    }

    private func assertAction(_ action: Action?, shouldBeWillRefreshRealTime task: Cancelable) {
        let bitcoiRateAction = action as? BitcoinRateAction
        XCTAssertNotNil(bitcoiRateAction)
        if case let .willRefreshRealTime(t) = bitcoiRateAction! {
            let lhs = t as? Cancelable
            XCTAssertNotNil(lhs)
            XCTAssertEqual(lhs!.id, task.id)
        } else {
            XCTFail("Wrong action triggered")
        }
    }

    private func assertAction(_ action: Action?, shouldBeDidRefreshRealTime result: Result<RealTimeResponse>) {
        let bitcoiRateAction = action as? BitcoinRateAction
        XCTAssertNotNil(bitcoiRateAction)
        if case let .didRefreshRealTime(r) = bitcoiRateAction! {
            XCTAssertEqual(r, result)
        } else {
            XCTFail("Wrong action triggered")
        }
    }

    private func assertAction(_ action: Action?, shouldBeWillRefreshHistoricalData task: Cancelable) {
        let bitcoiRateAction = action as? BitcoinRateAction
        XCTAssertNotNil(bitcoiRateAction)
        if case let .willRefreshHistoricalData(t) = bitcoiRateAction! {
            let lhs = t as? Cancelable
            XCTAssertNotNil(lhs)
            XCTAssertEqual(lhs!.id, task.id)
        } else {
            XCTFail("Wrong action triggered")
        }
    }

    private func assertAction(_ action: Action?, shouldBeDidRefreshHistoricalData result: Result<HistoricalResponse>) {
        let bitcoiRateAction = action as? BitcoinRateAction
        XCTAssertNotNil(bitcoiRateAction)
        if case let .didRefreshHistoricalData(r) = bitcoiRateAction! {
            XCTAssertEqual(r, result)
        } else {
            XCTFail("Wrong action triggered")
        }
    }
}
