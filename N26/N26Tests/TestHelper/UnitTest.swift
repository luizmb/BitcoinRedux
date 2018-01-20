//
//  UnitTest.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import XCTest
@testable import N26

class UnitTest: XCTestCase {
    override func setUp() {
        let injector = MockInjector()
        MockInjector.getInjector = { injector }
    }

    override func tearDown() {
        MockInjector.getInjector = { nil }
    }
}
