//
//  BitcoinEndpointTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26

class BitcoinEndpointTests: UnitTest {
    func testURLEndpoint_URLRequestFactory() {
        let realtimeEuro = BitcoinEndpoint.realtime(currency: "EUR").urlRequest
        let realtimeDolar = BitcoinEndpoint.realtime(currency: "USD").urlRequest
        let historicalEuro = BitcoinEndpoint.historical(currency: "EUR",
                                                        startDate: Date(timeIntervalSince1970: 0),
                                                        endDate: Date(timeIntervalSinceReferenceDate: 0)).urlRequest

        XCTAssertEqual(realtimeEuro.httpMethod, "GET")
        XCTAssertEqual(realtimeEuro.url?.absoluteString, "https://api.coindesk.com/v1/bpi/currentprice/EUR.json")

        XCTAssertEqual(realtimeDolar.httpMethod, "GET")
        XCTAssertEqual(realtimeDolar.url?.absoluteString, "https://api.coindesk.com/v1/bpi/currentprice/USD.json")

        XCTAssertEqual(historicalEuro.httpMethod, "GET")
        XCTAssertTrue([
            "https://api.coindesk.com/v1/bpi/historical/close.json?currency=EUR&start=1970-01-01&end=2001-01-01",
            "https://api.coindesk.com/v1/bpi/historical/close.json?currency=EUR&end=2001-01-01&start=1970-01-01",
            "https://api.coindesk.com/v1/bpi/historical/close.json?start=1970-01-01&currency=EUR&end=2001-01-01",
            "https://api.coindesk.com/v1/bpi/historical/close.json?start=1970-01-01&end=2001-01-01&currency=EUR",
            "https://api.coindesk.com/v1/bpi/historical/close.json?end=2001-01-01&currency=EUR&start=1970-01-01",
            "https://api.coindesk.com/v1/bpi/historical/close.json?end=2001-01-01&start=1970-01-01&currency=EUR",
            ].contains(historicalEuro.url!.absoluteString))
    }
}
