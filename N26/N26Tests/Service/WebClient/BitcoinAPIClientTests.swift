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

class BitcoinAPIClientTests: UnitTest {
    func testAPIValidResponse() {
        let shouldGetValidResponse: XCTestExpectation = expectation(description: "Valid response")
        let client = BitcoinAPIClient(session: URLSession.shared)

        client.request(.realtime(currency: "EUR")) { r in
            switch r {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 10)
                shouldGetValidResponse.fulfill()
            case .error(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }
        wait(for: [shouldGetValidResponse], timeout: 10)
    }

    func testAPIInvalidResponse() {
        let shouldGetInvalidResponse: XCTestExpectation = expectation(description: "Invalid response")
        let client = BitcoinAPIClient(session: URLSession.shared)

        client.request(.realtime(currency: "MMMMMMMM")) { r in
            switch r {
            case .success(let data):
                XCTFail("Unexpected data: \(String(data: data, encoding: .utf8)!)")
            case .error:
                shouldGetInvalidResponse.fulfill()
            }
        }
        wait(for: [shouldGetInvalidResponse], timeout: 10)
    }
}
