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
@testable import CommonLibrary

class UnitTest: XCTestCase {
    var injector: MockInjector!

    override func setUp() {
        injector = MockInjector()
        MockInjector.getInjector = { [unowned self] in self.injector }
    }

    override func tearDown() {
        MockInjector.getInjector = { nil }
    }
}
