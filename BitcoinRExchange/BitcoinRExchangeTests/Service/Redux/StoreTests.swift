import XCTest
import Foundation
@testable import BitcoinRExchange
@testable import BitcoinLibrary
@testable import CommonLibrary

class StoreTests: UnitTest {
    func testStateProviderMapping() {
        injector.injectDefaults()
        let subscription1TriggerOnSubscribe: XCTestExpectation = expectation(description: "Trigger 1 OnSubscribe")
        let subscription2TriggerOnSubscribe: XCTestExpectation = expectation(description: "Trigger 2 OnSubscribe")
        let subscription3TriggerOnSubscribe: XCTestExpectation = expectation(description: "Trigger 3 OnSubscribe")
        let subscription4TriggerOnSubscribe: XCTestExpectation = expectation(description: "Trigger 4 OnSubscribe")
        let subscription5TriggerOnSubscribe: XCTestExpectation = expectation(description: "Trigger 5 OnSubscribe")

        let subscription1TriggerOnChange: XCTestExpectation = expectation(description: "Trigger 1 OnChange")
        let subscription2TriggerOnChange: XCTestExpectation = expectation(description: "Trigger 2 OnChange")
        let subscription3TriggerOnChange: XCTestExpectation = expectation(description: "Trigger 3 OnChange")
        let subscription4TriggerOnChange: XCTestExpectation = expectation(description: "Trigger 4 OnChange")
        let subscription5TriggerOnChange: XCTestExpectation = expectation(description: "Trigger 5 OnChange")

        class Foo {
            var bag: [Any] = []

            var subscription1TriggerOnSubscribe: XCTestExpectation!
            var subscription2TriggerOnSubscribe: XCTestExpectation!
            var subscription3TriggerOnSubscribe: XCTestExpectation!
            var subscription4TriggerOnSubscribe: XCTestExpectation!
            var subscription5TriggerOnSubscribe: XCTestExpectation!
            var subscription1TriggerOnChange: XCTestExpectation!
            var subscription2TriggerOnChange: XCTestExpectation!
            var subscription3TriggerOnChange: XCTestExpectation!
            var subscription4TriggerOnChange: XCTestExpectation!
            var subscription5TriggerOnChange: XCTestExpectation!

            let date2001 = Date(timeIntervalSinceReferenceDate: 0)
            var step = 0
            var count1 = 0
            var count2 = 0
            var count3 = 0
            var count4 = 0
            var count5 = 0

            init() { }

            // 0 - subscribe
            // 1 - trigger change on bitcoinState.localTimeLastUpdateRealTime
            // 2 - trigger change on bitcoinState.localTimeLastUpdateHistorical
            // 3 - localTimeLastUpdateRealTime set to same value
            // 4 - bitcoinState.localTimeLastUpdateHistorical set to same value
            // 5 - trigger change on appState.historicalDays
            // 6 - appState.historicalDays set to same value
            func subscribe() {
                Store.shared.map { $0.bitcoinState }.subscribe { [unowned self] bitcoinState in
                    self.count1 += 1
                    switch self.step {
                    case 0:
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateRealTime, .distantPast)
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateHistorical, .distantPast)
                        self.subscription1TriggerOnSubscribe.fulfill()
                    case 1:
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateHistorical, .distantPast)
                        self.subscription1TriggerOnChange.fulfill()
                    case 2:
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateHistorical, self.date2001)
                    default:
                        XCTFail("We don't want subscriber 1 to be notified on step \(self.step)")
                    }
                }.addDisposableTo(&bag)
                // First 3 are identical with different syntax.
                // We expect them to be triggered all the times,
                // expect the last
                Store.shared.map(\.bitcoinState).subscribe { [unowned self] bitcoinState in
                    self.count2 += 1
                    switch self.step {
                    case 0:
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateRealTime, .distantPast)
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateHistorical, .distantPast)
                        self.subscription2TriggerOnSubscribe.fulfill()
                    case 1:
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateHistorical, .distantPast)
                        self.subscription2TriggerOnChange.fulfill()
                    case 2:
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateHistorical, self.date2001)
                    default:
                        XCTFail("We don't want subscriber 2 to be notified on step \(self.step)")
                    }
                }.addDisposableTo(&bag)
                Store.shared[\.bitcoinState].subscribe { [unowned self] bitcoinState in
                    self.count3 += 1
                    switch self.step {
                    case 0:
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateRealTime, .distantPast)
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateHistorical, .distantPast)
                        self.subscription3TriggerOnSubscribe.fulfill()
                    case 1:
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateHistorical, .distantPast)
                        self.subscription3TriggerOnChange.fulfill()
                    case 2:
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(bitcoinState.localTimeLastUpdateHistorical, self.date2001)
                    default:
                        XCTFail("We don't want subscriber 3 to be notified on step \(self.step)")
                    }
                }.addDisposableTo(&bag)
                Store.shared.subscribe(if: {
                    $0?.bitcoinState.localTimeLastUpdateHistorical != $1.bitcoinState.localTimeLastUpdateHistorical
                }) { [unowned self] state in
                    self.count4 += 1
                    switch self.step {
                    case 0:
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateRealTime, .distantPast)
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateHistorical, .distantPast)
                        XCTAssertEqual(state.historicalDays, 14)
                        self.subscription4TriggerOnSubscribe.fulfill()
                    case 2:
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateHistorical, self.date2001)
                        self.subscription4TriggerOnChange.fulfill()
                    default:
                        XCTFail("We don't want subscriber 4 to be notified on step \(self.step)")
                    }
                }.addDisposableTo(&bag)
                Store.shared.subscribe { [unowned self] state in
                    self.count5 += 1
                    switch self.step {
                    case 0:
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateRealTime, .distantPast)
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateHistorical, .distantPast)
                        XCTAssertEqual(state.historicalDays, 14)
                        self.subscription5TriggerOnSubscribe.fulfill()
                    case 1:
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateHistorical, .distantPast)
                        XCTAssertEqual(state.historicalDays, 14)
                        self.subscription5TriggerOnChange.fulfill()
                    case 2:
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateHistorical, self.date2001)
                        XCTAssertEqual(state.historicalDays, 14)
                    case 5:
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateRealTime, self.date2001)
                        XCTAssertEqual(state.bitcoinState.localTimeLastUpdateHistorical, self.date2001)
                        XCTAssertEqual(state.historicalDays, 13)
                    default:
                        XCTFail("We don't want subscriber 3 to be notified on step \(self.step)")
                    }
                }.addDisposableTo(&bag)
            }
        }
        let foo = Foo()
        foo.subscription1TriggerOnSubscribe = subscription1TriggerOnSubscribe
        foo.subscription2TriggerOnSubscribe = subscription2TriggerOnSubscribe
        foo.subscription3TriggerOnSubscribe = subscription3TriggerOnSubscribe
        foo.subscription4TriggerOnSubscribe = subscription4TriggerOnSubscribe
        foo.subscription5TriggerOnSubscribe = subscription5TriggerOnSubscribe
        foo.subscription1TriggerOnChange = subscription1TriggerOnChange
        foo.subscription2TriggerOnChange = subscription2TriggerOnChange
        foo.subscription3TriggerOnChange = subscription3TriggerOnChange
        foo.subscription4TriggerOnChange = subscription4TriggerOnChange
        foo.subscription5TriggerOnChange = subscription5TriggerOnChange

        foo.subscribe()
        foo.step = 0 // 0 - subscribe
        // When subscribe, immediately we expect to be notified
        wait(for: [subscription1TriggerOnSubscribe], timeout: 1)
        wait(for: [subscription2TriggerOnSubscribe], timeout: 1)
        wait(for: [subscription3TriggerOnSubscribe], timeout: 1)
        wait(for: [subscription4TriggerOnSubscribe], timeout: 1)
        wait(for: [subscription5TriggerOnSubscribe], timeout: 1)
        XCTAssertEqual(foo.count1, 1)
        XCTAssertEqual(foo.count2, 1)
        XCTAssertEqual(foo.count3, 1)
        XCTAssertEqual(foo.count4, 1)
        XCTAssertEqual(foo.count5, 1)

        foo.step = 1 // 1 - trigger change on bitcoinState.localTimeLastUpdateRealTime
        // When localTimeLastUpdateRealTime changes, all subscriptions should
        // be notified, except the number 4, with filter to localTimeLastUpdateHistorical field
        Store.shared.currentState.bitcoinState.localTimeLastUpdateRealTime = foo.date2001
        wait(for: [subscription1TriggerOnChange], timeout: 1)
        wait(for: [subscription2TriggerOnChange], timeout: 1)
        wait(for: [subscription3TriggerOnChange], timeout: 1)
        wait(for: [subscription5TriggerOnChange], timeout: 1)
        XCTAssertEqual(foo.count1, 2)
        XCTAssertEqual(foo.count2, 2)
        XCTAssertEqual(foo.count3, 2)
        XCTAssertEqual(foo.count4, 1)
        XCTAssertEqual(foo.count5, 2)

        foo.step = 2 // 2 - trigger change on bitcoinState.localTimeLastUpdateHistorical
        // When the localTimeLastUpdateHistorical changes, then all subscriptions should
        // be notified, including the number 4
        Store.shared.currentState.bitcoinState.localTimeLastUpdateHistorical = foo.date2001
        wait(for: [subscription4TriggerOnChange], timeout: 1)
        XCTAssertEqual(foo.count1, 3)
        XCTAssertEqual(foo.count2, 3)
        XCTAssertEqual(foo.count3, 3)
        XCTAssertEqual(foo.count4, 2)
        XCTAssertEqual(foo.count5, 3)

        foo.step = 3 // 3 - localTimeLastUpdateRealTime set to same value
        // Nothing changes as we are setting to the same value. No subscriber will be notified.
        Store.shared.currentState.bitcoinState.localTimeLastUpdateRealTime = foo.date2001
        XCTAssertEqual(foo.count1, 3)
        XCTAssertEqual(foo.count2, 3)
        XCTAssertEqual(foo.count3, 3)
        XCTAssertEqual(foo.count4, 2)
        XCTAssertEqual(foo.count5, 3)

        foo.step = 4 // 4 - bitcoinState.localTimeLastUpdateHistorical set to same value
        // Nothing changes as we are setting to the same value. No subscriber will be notified.
        Store.shared.currentState.bitcoinState.localTimeLastUpdateHistorical = foo.date2001
        XCTAssertEqual(foo.count1, 3)
        XCTAssertEqual(foo.count2, 3)
        XCTAssertEqual(foo.count3, 3)
        XCTAssertEqual(foo.count4, 2)
        XCTAssertEqual(foo.count5, 3)

        foo.step = 5 // 5 - trigger change on appState.historicalDays
        // The first 3 subscribers won't be notified as they are mapped to bitcoinState
        // The fourth is mapped to appState, but it has a filter for one particular property
        // not the one we are changing.
        // The last subscriber should be the only to be notified
        Store.shared.currentState.historicalDays = 13
        XCTAssertEqual(foo.count1, 3)
        XCTAssertEqual(foo.count2, 3)
        XCTAssertEqual(foo.count3, 3)
        XCTAssertEqual(foo.count4, 2)
        XCTAssertEqual(foo.count5, 3)

        foo.step = 6 // 6 - appState.historicalDays set to same value
        // Nothing changes as we are setting to the same value. No subscriber will be notified.
        Store.shared.currentState.historicalDays = 13
        XCTAssertEqual(foo.count1, 3)
        XCTAssertEqual(foo.count2, 3)
        XCTAssertEqual(foo.count3, 3)
        XCTAssertEqual(foo.count4, 2)
        XCTAssertEqual(foo.count5, 3)
    }
}
