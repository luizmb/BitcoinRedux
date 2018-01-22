//
//  ModelTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26
@testable import BitcoinLibrary
@testable import CommonLibrary

class ModelTests: UnitTest {
    func testBitcoinRealTimeRateEquatable() {
        let dateA = Date()
        let dateB = Date(timeIntervalSinceReferenceDate: 0)
        let sutA = BitcoinRealTimeRate(currency: Currency(code: "A", name: "A"),
                                       lastUpdate: dateA,
                                       rate: 1.0)
        let sutA2 = BitcoinRealTimeRate(currency: Currency(code: "A", name: "A"),
                                        lastUpdate: dateA,
                                        rate: 1.0)
        let sutB = BitcoinRealTimeRate(currency: Currency(code: "B", name: "A"),
                                       lastUpdate: dateA,
                                       rate: 1.0)
        let sutC = BitcoinRealTimeRate(currency: Currency(code: "A", name: "A"),
                                       lastUpdate: dateB,
                                       rate: 1.0)
        let sutD = BitcoinRealTimeRate(currency: Currency(code: "A", name: "A"),
                                       lastUpdate: dateA,
                                       rate: 1.1)
        XCTAssertTrue(sutA == sutA2)
        XCTAssertFalse(sutA == sutB)
        XCTAssertFalse(sutA == sutC)
        XCTAssertFalse(sutA == sutD)
    }

    func testBitcoinHistoricalRateEquatable() {
        let dateA = Date()
        let dateB = Date(timeIntervalSinceReferenceDate: 0)
        let sutA = BitcoinHistoricalRate(currency: Currency(code: "A", name: "A"),
                                         closedDate: dateA,
                                         rate: 1.0)
        let sutA2 = BitcoinHistoricalRate(currency: Currency(code: "A", name: "A"),
                                          closedDate: dateA,
                                          rate: 1.0)
        let sutB = BitcoinHistoricalRate(currency: Currency(code: "B", name: "A"),
                                         closedDate: dateA,
                                         rate: 1.0)
        let sutC = BitcoinHistoricalRate(currency: Currency(code: "A", name: "A"),
                                         closedDate: dateB,
                                         rate: 1.0)
        let sutD = BitcoinHistoricalRate(currency: Currency(code: "A", name: "A"),
                                         closedDate: dateA,
                                         rate: 1.1)
        XCTAssertTrue(sutA == sutA2)
        XCTAssertFalse(sutA == sutB)
        XCTAssertFalse(sutA == sutC)
        XCTAssertFalse(sutA == sutD)
    }

    func testCurrencyEquatable() {
        let currency_ab1 = Currency(code: "A", name: "B", symbol: "$")
        let currency_ab2 = Currency(code: "A", name: "B")
        let currency_aa = Currency(code: "A", name: "A")
        let currency_bb = Currency(code: "B", name: "B")
        let currency_ba = Currency(code: "B", name: "A")

        XCTAssertTrue(currency_ab1 == currency_ab2)
        XCTAssertTrue(currency_ab1 == currency_aa)
        XCTAssertTrue(currency_ab2 == currency_aa)
        XCTAssertTrue(currency_bb == currency_ba)
        XCTAssertFalse(currency_ab1 == currency_bb)
        XCTAssertFalse(currency_ab1 == currency_ba)
        XCTAssertFalse(currency_ab2 == currency_bb)
        XCTAssertFalse(currency_ab2 == currency_ba)
        XCTAssertFalse(currency_aa == currency_bb)
        XCTAssertFalse(currency_aa == currency_ba)
    }

    func testRateEquatable() {
        let rate_ab1 = Rate(date: Date(timeIntervalSince1970: 0), rate: 2.0)
        let rate_ab2 = Rate(date: Date(timeIntervalSince1970: 0), rate: 2.0)
        let rate_aa = Rate(date: Date(timeIntervalSince1970: 0), rate: 1.0)
        let rate_bb = Rate(date: Date(timeIntervalSinceReferenceDate: 0), rate: 2.0)
        let rate_ba = Rate(date: Date(timeIntervalSinceReferenceDate: 0), rate: 1.0)

        XCTAssertTrue(rate_ab1 == rate_ab2)
        XCTAssertFalse(rate_ab1 == rate_aa)
        XCTAssertFalse(rate_ab1 == rate_bb)
        XCTAssertFalse(rate_ab1 == rate_ba)
        XCTAssertFalse(rate_ab2 == rate_aa)
        XCTAssertFalse(rate_ab2 == rate_bb)
        XCTAssertFalse(rate_ab2 == rate_ba)
        XCTAssertFalse(rate_aa == rate_bb)
        XCTAssertFalse(rate_aa == rate_ba)
        XCTAssertFalse(rate_bb == rate_ba)
    }

    func testHistoricalEquatable() {
        let historical_a1 = HistoricalResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                               disclaimer: "A",
                                               bpi: [Rate(date: Date(timeIntervalSince1970: 0), rate: 1.0),
                                                     Rate(date: Date(timeIntervalSinceReferenceDate: 0), rate: 2.0)])
        let historical_a2 = HistoricalResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                               disclaimer: "A",
                                               bpi: [Rate(date: Date(timeIntervalSince1970: 0), rate: 1.0),
                                                     Rate(date: Date(timeIntervalSinceReferenceDate: 0), rate: 2.0)])
        let historical_b = HistoricalResponse(updatedTime: Date(timeIntervalSinceReferenceDate: 0),
                                              disclaimer: "A",
                                              bpi: [Rate(date: Date(timeIntervalSince1970: 0), rate: 1.0),
                                                    Rate(date: Date(timeIntervalSinceReferenceDate: 0), rate: 2.0)])
        let historical_c = HistoricalResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                              disclaimer: "B",
                                              bpi: [Rate(date: Date(timeIntervalSince1970: 0), rate: 1.0),
                                                    Rate(date: Date(timeIntervalSinceReferenceDate: 0), rate: 2.0)])
        let historical_d = HistoricalResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                              disclaimer: "A",
                                              bpi: [Rate(date: Date(timeIntervalSince1970: 0), rate: 2.0),
                                                    Rate(date: Date(timeIntervalSinceReferenceDate: 0), rate: 2.0)])
        let historical_e = HistoricalResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                              disclaimer: "A",
                                              bpi: [Rate(date: Date(timeIntervalSince1970: 0), rate: 1.0),
                                                    Rate(date: Date(timeIntervalSinceReferenceDate: 1), rate: 2.0)])
        let historical_f = HistoricalResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                               disclaimer: "A",
                                               bpi: [Rate(date: Date(timeIntervalSinceReferenceDate: 0), rate: 2.0)])
        XCTAssertTrue(historical_a1 == historical_a2)
        XCTAssertFalse(historical_a1 == historical_b)
        XCTAssertFalse(historical_a1 == historical_c)
        XCTAssertFalse(historical_a1 == historical_d)
        XCTAssertFalse(historical_a1 == historical_e)
        XCTAssertFalse(historical_a1 == historical_f)
    }

    func testRealtimeEquatable() {
        let realtime_a1 = RealTimeResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                           disclaimer: "A",
                                           bpi: [Currency(code: "A", name: ""): 1.0,
                                                 Currency(code: "B", name: ""): 2.0])
        let realtime_a2 = RealTimeResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                           disclaimer: "A",
                                           bpi: [Currency(code: "A", name: ""): 1.0,
                                                 Currency(code: "B", name: ""): 2.0])
        let realtime_b = RealTimeResponse(updatedTime: Date(timeIntervalSinceReferenceDate: 0),
                                          disclaimer: "A",
                                          bpi: [Currency(code: "A", name: ""): 1.0,
                                                Currency(code: "B", name: ""): 2.0])
        let realtime_c = RealTimeResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                          disclaimer: "B",
                                          bpi: [Currency(code: "A", name: ""): 1.0,
                                                Currency(code: "B", name: ""): 2.0])
        let realtime_d = RealTimeResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                          disclaimer: "A",
                                          bpi: [Currency(code: "A", name: ""): 2.0,
                                                Currency(code: "B", name: ""): 2.0])
        let realtime_e = RealTimeResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                          disclaimer: "A",
                                          bpi: [Currency(code: "A", name: ""): 1.0,
                                                Currency(code: "C", name: ""): 2.0])
        let realtime_f = RealTimeResponse(updatedTime: Date(timeIntervalSince1970: 0),
                                           disclaimer: "A",
                                           bpi: [Currency(code: "B", name: ""): 2.0])
        XCTAssertTrue(realtime_a1 == realtime_a2)
        XCTAssertFalse(realtime_a1 == realtime_b)
        XCTAssertFalse(realtime_a1 == realtime_c)
        XCTAssertFalse(realtime_a1 == realtime_d)
        XCTAssertFalse(realtime_a1 == realtime_e)
        XCTAssertFalse(realtime_a1 == realtime_f)
    }

    func testKnownRouteEquatable() {
        let a = MockRoute()
        a.route = NavigationRoute(origin: .root(), destination: .root())
        let b = MockRoute()
        b.route = NavigationRoute(origin: .root(), destination: .root())
        XCTAssertTrue(a == b)
    }
}
