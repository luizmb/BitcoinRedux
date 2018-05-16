import Foundation
import XCTest
@testable import BitcoinRExchange
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
