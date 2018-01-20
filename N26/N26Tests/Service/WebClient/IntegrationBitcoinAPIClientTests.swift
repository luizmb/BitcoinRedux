//
//  BitcoinAPIClientTests.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import Foundation
@testable import N26

class IntegrationBitcoinAPIClientTests: UnitTest {
    func testRealTimeAPIValidResponse() {
        let shouldGetValidResponse: XCTestExpectation = expectation(description: "Valid response")
        let client = BitcoinAPIClient(session: URLSession.shared)

        client.request(.realtime(currency: "EUR")) { httpResult in
            switch httpResult {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 10)
                shouldGetValidResponse.fulfill()
            case .error(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }
        wait(for: [shouldGetValidResponse], timeout: 10)
    }

    func testRealTimeAPIInvalidResponse() {
        let shouldGetInvalidResponse: XCTestExpectation = expectation(description: "Invalid response")
        let client = BitcoinAPIClient(session: URLSession.shared)

        client.request(.realtime(currency: "MMMMMMMM")) { httpResult in
            switch httpResult {
            case .success(let data):
                XCTFail("Unexpected data: \(String(data: data, encoding: .utf8)!)")
            case .error:
                shouldGetInvalidResponse.fulfill()
            }
        }
        wait(for: [shouldGetInvalidResponse], timeout: 10)
    }

    func testHistoricalAPIValidResponse() {
        let shouldGetValidResponse: XCTestExpectation = expectation(description: "Valid response")
        let client = BitcoinAPIClient(session: URLSession.shared)

        client.request(.historical(currency: "EUR",
                                   startDate: Date().backToMidnight.addingDays(-2),
                                   endDate: Date())) { httpResult in
            switch httpResult {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 10)
                shouldGetValidResponse.fulfill()
            case .error(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }
        wait(for: [shouldGetValidResponse], timeout: 10)
    }

    func testHistoricalAPIInvalidResponse() {
        let shouldGetInvalidResponse: XCTestExpectation = expectation(description: "Invalid response")
        let client = BitcoinAPIClient(session: URLSession.shared)

        client.request(.historical(currency: "MMMMMMMM",
                                   startDate: Date().backToMidnight.addingDays(-2),
                                   endDate: Date())) { httpResult in
            switch httpResult {
            case .success(let data):
                XCTFail("Unexpected data: \(String(data: data, encoding: .utf8)!)")
            case .error:
                shouldGetInvalidResponse.fulfill()
            }
        }
        wait(for: [shouldGetInvalidResponse], timeout: 10)
    }

    func testRealTimeAPIIntegrationTest() {
        let shouldGetValidResponse: XCTestExpectation = expectation(description: "Valid response")
        let client = BitcoinAPIClient(session: URLSession.shared)

        client.request(.realtime(currency: "EUR")) { httpResult in
            let jsonResult: Result<RealTimeResponse> = httpResult.flatMap(JsonParser.decode)
            switch jsonResult {
            case .success(let realtimeResponse):
                XCTAssertTrue(realtimeResponse.updatedTime.backToMidnight == Date().backToMidnight)
                XCTAssertNotNil(realtimeResponse.disclaimer)
                XCTAssertEqual(realtimeResponse.bpi.count, 2)
                let rate = realtimeResponse.bpi[Currency(code: "EUR", name: "")]
                XCTAssertNotNil(rate)
                XCTAssertGreaterThan(rate!, 1000)
                shouldGetValidResponse.fulfill()
            case .error(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }
        wait(for: [shouldGetValidResponse], timeout: 10)
    }

    func testHistoricalAPIIntegrationTest() {
        let shouldGetValidResponse: XCTestExpectation = expectation(description: "Valid response")
        let client = BitcoinAPIClient(session: URLSession.shared)

        client.request(.historical(currency: "EUR",
                       startDate: Date().backToMidnight.addingDays(-14),
                       endDate: Date())) { httpResult in
            let jsonResult: Result<HistoricalResponse> = httpResult.flatMap(JsonParser.decode)
            switch jsonResult {
            case .success(let historicalResponse):
                XCTAssertTrue(historicalResponse.updatedTime.backToMidnight == Date().backToMidnight)
                XCTAssertNotNil(historicalResponse.disclaimer)
                XCTAssertGreaterThanOrEqual(historicalResponse.bpi.count, 13)
                historicalResponse.bpi.forEach { day in
                    XCTAssertLessThan(day.date, Date())
                    XCTAssertGreaterThan(day.date, Date().backToMidnight.addingDays(-15))
                    XCTAssertGreaterThan(day.rate, 1000)
                }
                shouldGetValidResponse.fulfill()
            case .error(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }
        wait(for: [shouldGetValidResponse], timeout: 10)
    }
}
