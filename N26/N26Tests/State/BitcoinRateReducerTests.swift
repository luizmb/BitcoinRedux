//
//  ReducerTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26

class BitcoinRateReducerTests: UnitTest {
    let appState = AppState()
    let reducer = BitcoinRateReducer()

    func testBitcoinReducerFoo() {
        let newState = reducer.reduce(appState, action: FooAction.foo)
        XCTAssertEqual(appState, newState)
    }

    func testBitcoinReducerWillRefreshRealTime() {
        let newState = reducer.reduce(appState, action: BitcoinRateAction.willRefreshRealTime(Cancelable()))
        XCTAssertNotEqual(appState, newState)
        XCTAssertNotEqual(appState.bitcoinState.realtimeRate, newState.bitcoinState.realtimeRate)
        XCTAssertEqual(newState.bitcoinState.realtimeRate, .syncing(task: Cancelable(), oldValue: nil))
    }

    func testBitcoinReducerWillRefreshHistorical() {
        let newState = reducer.reduce(appState, action: BitcoinRateAction.willRefreshHistoricalData(Cancelable()))
        XCTAssertNotEqual(appState, newState)
        XCTAssertNotEqual(appState.bitcoinState.historicalRates, newState.bitcoinState.historicalRates)
        XCTAssertEqual(newState.bitcoinState.historicalRates, .syncing(task: Cancelable(), oldValue: nil))
    }

    func testBitcoinReducerDidRefreshRealTimeWithError() {
        let newState = reducer.reduce(appState, action: BitcoinRateAction.didRefreshRealTime(.error(AnyError())))
        XCTAssertNotEqual(appState, newState)
        XCTAssertNotEqual(appState.bitcoinState.realtimeRate, newState.bitcoinState.realtimeRate)
        XCTAssertEqual(newState.bitcoinState.realtimeRate, .loaded(.error(AnyError())))
    }

    func testBitcoinReducerDidRefreshRealTimeWithSuccess() {
        let newState = reducer.reduce(appState, action: BitcoinRateAction.didRefreshRealTime(.success(RealTimeResponse.mock)))
        XCTAssertNotEqual(appState, newState)
        XCTAssertNotEqual(appState.bitcoinState.realtimeRate, newState.bitcoinState.realtimeRate)
        XCTAssertEqual(newState.bitcoinState.realtimeRate, .loaded(.success(BitcoinRealTimeRate.mock)))
    }

    func testBitcoinReducerDidRefreshHistoricalDataWithError() {
        let newState = reducer.reduce(appState, action: BitcoinRateAction.didRefreshHistoricalData(.error(AnyError())))
        XCTAssertNotEqual(appState, newState)
        XCTAssertNotEqual(appState.bitcoinState.historicalRates, newState.bitcoinState.historicalRates)
        XCTAssertEqual(newState.bitcoinState.historicalRates, .loaded(.error(AnyError())))
    }

    func testBitcoinReducerDidRefreshHistoricalDataWithSuccess() {
        let newState = reducer.reduce(appState, action: BitcoinRateAction.didRefreshHistoricalData(.success(HistoricalResponse.mock)))
        XCTAssertNotEqual(appState, newState)
        XCTAssertNotEqual(appState.bitcoinState.historicalRates, newState.bitcoinState.historicalRates)
        XCTAssertEqual(newState.bitcoinState.historicalRates, .loaded(.success([BitcoinHistoricalRate].mock)))
    }
}
