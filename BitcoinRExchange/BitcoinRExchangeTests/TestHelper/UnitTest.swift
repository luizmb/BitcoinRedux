@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import XCTest

class UnitTest: XCTestCase {
    var injector: MockInjector!

    override func setUp() {
        super.setUp()
        injector = MockInjector()
        MockInjector.getInjector = { [unowned self] in self.injector }
    }

    override func tearDown() {
        super.tearDown()
        MockInjector.getInjector = { nil }
    }
}
