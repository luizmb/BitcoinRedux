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
@testable import BitcoinLibrary
@testable import CommonLibrary

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

        let mockRepository = MockRepository()
        mockRepository.onCallSave = { [weak self] data, name in
            XCTAssertEqual(name, "realtime_cache.bin")
            XCTAssertEqual(data, Data())
            XCTAssertEqual(actions.count, 1)
            self?.assertAction(actions.first, shouldBeWillRefreshRealTime: newTask)
            XCTAssertEqual(asyncActions.count, 0)
        }
        mockRepository.onCallLoad = { _ in
            XCTFail("Should not be loading a file in here")
            return .error(AnyError())
        }
        injector.mapper.mapSingleton(RepositoryProtocol.self) { mockRepository }

        BitcoinRateRequest
            .realtimeRefresh(isManual: false)
            .execute(getState: { state },
                     dispatch: { actions.append($0) },
                     dispatchAsync: { asyncActions.append($0) })

        XCTAssertEqual(oldTask.cancelCount, 1)
        XCTAssertEqual(actions.count, 1)
        assertAction(actions.first, shouldBeWillRefreshRealTime: newTask)
        mockAPI.calledRequest?.1(.success(Data()))

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

        let mockRepository = MockRepository()
        mockRepository.onCallSave = { [weak self] data, name in
            XCTAssertEqual(name, "historical_cache.bin")
            XCTAssertEqual(data, Data())
            XCTAssertEqual(actions.count, 1)
            self?.assertAction(actions.first, shouldBeWillRefreshHistoricalData: newTask)
            XCTAssertEqual(asyncActions.count, 0)
        }
        mockRepository.onCallLoad = { _ in
            XCTFail("Should not be loading a file in here")
            return .error(AnyError())
        }
        injector.mapper.mapSingleton(RepositoryProtocol.self) { mockRepository }

        BitcoinRateRequest
            .historicalDataRefresh(isManual: false)
            .execute(getState: { state },
                     dispatch: { actions.append($0) },
                     dispatchAsync: { asyncActions.append($0) })

        XCTAssertEqual(oldTask.cancelCount, 1)
        XCTAssertEqual(actions.count, 1)
        assertAction(actions.first, shouldBeWillRefreshHistoricalData: newTask)
        mockAPI.calledRequest?.1(.success(Data()))

        XCTAssertEqual(actions.count, 2)
        assertAction(actions.first, shouldBeWillRefreshHistoricalData: newTask)
        assertAction(actions[1], shouldBeDidRefreshHistoricalData: .error(AnyError()))
    }

    func testBootstrapRequestRealTimeCache() {
        let state = AppState()
        var actions: [Action] = []
        var asyncActions: [AnyActionAsync<AppState>] = []
        let mockRepository = MockRepository()
        mockRepository.onCallSave = { _, _ in
            XCTFail("Should not be saving a file in here")
            return
        }
        mockRepository.onCallLoad = { name in
            XCTAssertEqual(name, "realtime_cache.bin")
            XCTAssertEqual(actions.count, 0)
            XCTAssertEqual(asyncActions.count, 0)
            return .error(AnyError())
        }
        injector.mapper.mapSingleton(RepositoryProtocol.self) { mockRepository }

        BitcoinRateRequest
            .realtimeCache
            .execute(getState: { state },
                     dispatch: { actions.append($0) },
                     dispatchAsync: { asyncActions.append($0) })

        XCTAssertEqual(actions.count, 1)
        XCTAssertEqual(asyncActions.count, 0)
        assertAction(actions.first, shouldBeDidRefreshRealTime: .error(AnyError()))
    }

    func testBootstrapRequestHistoricalDataCache() {
        let state = AppState()
        var actions: [Action] = []
        var asyncActions: [AnyActionAsync<AppState>] = []
        let mockRepository = MockRepository()
        mockRepository.onCallSave = { _, _ in
            XCTFail("Should not be saving a file in here")
            return
        }
        mockRepository.onCallLoad = { name in
            XCTAssertEqual(name, "historical_cache.bin")
            XCTAssertEqual(actions.count, 0)
            XCTAssertEqual(asyncActions.count, 0)
            return .error(AnyError())
        }
        injector.mapper.mapSingleton(RepositoryProtocol.self) { mockRepository }

        BitcoinRateRequest
            .historicalCache
            .execute(getState: { state },
                     dispatch: { actions.append($0) },
                     dispatchAsync: { asyncActions.append($0) })

        XCTAssertEqual(actions.count, 1)
        XCTAssertEqual(asyncActions.count, 0)
        assertAction(actions.first, shouldBeDidRefreshHistoricalData: .error(AnyError()))
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
            switch (r, result) {
            case (.error, .error): break
            case (.success(let lhs), .success(let rhs)): XCTAssertEqual(lhs, rhs)
            default: XCTFail("Results differ")
            }

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
            switch (r, result) {
            case (.error, .error): break
            case (.success(let lhs), .success(let rhs)): XCTAssertEqual(lhs, rhs)
            default: XCTFail("Results differ")
            }
        } else {
            XCTFail("Wrong action triggered")
        }
    }
}
