@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import RxSwift
import SwiftRex
import XCTest

class BitcoinRateAPIMiddlewareTests: UnitTest {
    func testBitcoinRateAPIMiddlewareHandlesBitcoinRateEvent() {
        let sut = BitcoinRateAPIMiddleware()
        sut.actionHandler = MockActionHandler()

        let sideEffectProducer = sut.sideEffect(for: BitcoinRateEvent.setup)
        XCTAssertNotNil(sideEffectProducer)
    }

    func testBitcoinRateAPIMiddlewareDoesNotHandleApplicationEvent() {
        let sut = BitcoinRateAPIMiddleware()
        sut.actionHandler = MockActionHandler()

        let sideEffectProducer = sut.sideEffect(for: ApplicationEvent.boot(application: UIApplication.shared,
                                                                           window: UIWindow(),
                                                                           launchOptions: nil))
        XCTAssertNil(sideEffectProducer)
    }
}
