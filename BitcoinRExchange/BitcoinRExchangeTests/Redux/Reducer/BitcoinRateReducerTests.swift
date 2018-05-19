@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
@testable import SwiftRex
import XCTest

class BitcoinRateReducerTests: UnitTest {
    let globalState = GlobalState()
    let sut = bitcoinRateReducer.lift(\GlobalState.bitcoinState)

    func testBitcoinReducerFoo() {
        let newState = sut.reduce(globalState, FooAction.foo)
        XCTAssertEqual(globalState, newState)
    }

    func testBitcoinReducerWillRefreshRealTime() {
        let newState = sut.reduce(globalState, BitcoinRateAction.willRefreshRealTime(Cancelable()))
        XCTAssertNotEqual(globalState, newState)
        XCTAssertNotEqual(globalState.bitcoinState.realtimeRate, newState.bitcoinState.realtimeRate)
        XCTAssertEqual(newState.bitcoinState.realtimeRate, .syncing(task: Cancelable(), oldValue: nil))
    }

    func testBitcoinReducerWillRefreshHistorical() {
        let newState = sut.reduce(globalState, BitcoinRateAction.willRefreshHistoricalData(Cancelable()))
        XCTAssertNotEqual(globalState, newState)
        XCTAssertNotEqual(globalState.bitcoinState.historicalRates, newState.bitcoinState.historicalRates)
        XCTAssertEqual(newState.bitcoinState.historicalRates, .syncing(task: Cancelable(), oldValue: nil))
    }

    func testBitcoinReducerDidRefreshRealTimeWithError() {
        let newState = sut.reduce(globalState, BitcoinRateAction.didRefreshRealTime(.error(AnyError())))
        XCTAssertNotEqual(globalState, newState)
        XCTAssertNotEqual(globalState.bitcoinState.realtimeRate, newState.bitcoinState.realtimeRate)
        XCTAssertEqual(newState.bitcoinState.realtimeRate, .loaded(.error(AnyError())))
    }

    func testBitcoinReducerDidRefreshRealTimeWithSuccess() {
        let newState = sut.reduce(globalState, BitcoinRateAction.didRefreshRealTime(.success(RealTimeResponse.mock)))
        XCTAssertNotEqual(globalState, newState)
        XCTAssertNotEqual(globalState.bitcoinState.realtimeRate, newState.bitcoinState.realtimeRate)
        XCTAssertEqual(newState.bitcoinState.realtimeRate, .loaded(.success(BitcoinRealTimeRate.mock)))
    }

    func testBitcoinReducerDidRefreshHistoricalDataWithError() {
        let newState = sut.reduce(globalState, BitcoinRateAction.didRefreshHistoricalData(.error(AnyError())))
        XCTAssertNotEqual(globalState, newState)
        XCTAssertNotEqual(globalState.bitcoinState.historicalRates, newState.bitcoinState.historicalRates)
        XCTAssertEqual(newState.bitcoinState.historicalRates, .loaded(.error(AnyError())))
    }

    func testBitcoinReducerDidRefreshHistoricalDataWithSuccess() {
        let newState = sut.reduce(globalState, BitcoinRateAction.didRefreshHistoricalData(.success(HistoricalResponse.mock)))
        XCTAssertNotEqual(globalState, newState)
        XCTAssertNotEqual(globalState.bitcoinState.historicalRates, newState.bitcoinState.historicalRates)
        XCTAssertEqual(newState.bitcoinState.historicalRates, .loaded(.success([BitcoinHistoricalRate].mock)))
    }
}
