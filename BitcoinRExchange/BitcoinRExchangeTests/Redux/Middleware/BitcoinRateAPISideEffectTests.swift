@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import Foundation
import RxBlocking
import RxSwift
import RxTest
import SwiftRex
import XCTest

class BitcoinRateAPISideEffectTests: UnitTest {
    var mockAPI: MockAPI!
    var mockRepository: MockRepository!

    override func setUp() {
        super.setUp()
        setUpMock()
    }

    private func setUpMock() {
        let mockAPI = MockAPI()
        injector.mapper.mapSingleton(BitcoinRateAPI.self) { mockAPI }
        self.mockAPI = mockAPI

        let mockRepository = MockRepository()
        injector.mapper.mapSingleton(RepositoryProtocol.self) { mockRepository }
        self.mockRepository = mockRepository

        mockRepository.onCallSave = { data, _ in
            XCTAssertEqual(data, Data())
        }
        mockRepository.onCallLoad = { _ in
            XCTFail("Should not be loading a file in here")
            return .error(AnyError())
        }
    }

    func testBitcoinRateAPISideEffectSetup() {
        given(state: BitcoinState(),
              thenDispatch: .setup,
              expectationsAfterRequest: bothRequests,
              expectationsAfterResponse: bothResponses)
    }

    func testBitcoinRateAPISideEffectAutomaticRefresh() {
        given(state: BitcoinState(),
              thenDispatch: .automaticRefresh,
              expectationsAfterRequest: bothRequests,
              expectationsAfterResponse: bothResponses)
    }

    func testBitcoinRateAPISideEffectAutomaticRefreshOnlyRealtimeExpired() {
        var state = BitcoinState()
        state.realtimeRateRefreshTime = 10
        state.historicalRatesRefreshTime = 10

        state.localTimeLastUpdateRealTime = Date().addingTimeInterval(-15)
        state.localTimeLastUpdateHistorical = Date()

        given(state: state,
              thenDispatch: .automaticRefresh,
              expectationsAfterRequest: realtimeRequest,
              expectationsAfterResponse: realtimeResponse)
    }

    func testBitcoinRateAPISideEffectAutomaticRefreshOnlyHistoricalExpired() {
        var state = BitcoinState()
        state.realtimeRateRefreshTime = 10
        state.historicalRatesRefreshTime = 10

        state.localTimeLastUpdateRealTime = Date()
        state.localTimeLastUpdateHistorical = Date().addingTimeInterval(-15)

        given(state: state,
              thenDispatch: .automaticRefresh,
              expectationsAfterRequest: historicalRequest,
              expectationsAfterResponse: historicalResponse)
    }

    func testBitcoinRateAPISideEffectAutomaticRefreshNoneExpired() {
        var state = BitcoinState()
        state.realtimeRateRefreshTime = 10
        state.historicalRatesRefreshTime = 10

        state.localTimeLastUpdateRealTime = Date()
        state.localTimeLastUpdateHistorical = Date()

        given(state: state,
              thenDispatch: .automaticRefresh,
              expectationsAfterRequest: empty,
              expectationsAfterResponse: empty)
    }

    func testBitcoinRateAPISideEffectManualRefresh() {
        given(state: BitcoinState(),
              thenDispatch: .manualRefresh,
              expectationsAfterRequest: bothRequests,
              expectationsAfterResponse: bothResponses)
    }

    func testBitcoinRateAPISideEffectManualRefreshNoneExpired() {
        var state = BitcoinState()
        state.realtimeRateRefreshTime = 10
        state.historicalRatesRefreshTime = 10

        state.localTimeLastUpdateRealTime = Date()
        state.localTimeLastUpdateHistorical = Date()

        given(state: state,
              thenDispatch: .manualRefresh,
              expectationsAfterRequest: bothRequests,
              expectationsAfterResponse: bothResponses)
    }

    func testBitcoinRateAPISideEffectCancelStaleRequest() {
        var state = BitcoinState()
        let cancelable = Cancelable()
        state.realtimeRate = .syncing(task: cancelable, oldValue: nil)

        given(state: state,
              thenDispatch: .manualRefresh,
              expectationsAfterRequest: bothRequests,
              expectationsAfterResponse: bothResponses)

        XCTAssertEqual(1, cancelable.cancelCount)
    }

    private func given(state: BitcoinState,
                       thenDispatch event: BitcoinRateEvent,
                       expectationsAfterRequest: @escaping ([Recorded<Event<ActionProtocol>>]) -> Void,
                       expectationsAfterResponse: @escaping ([Recorded<Event<ActionProtocol>>]) -> Void) {

        let sut = BitcoinRateAPISideEffect(event: event)

        let bag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(ActionProtocol.self)
        let result = sut.execute(getState: { state })
        result.subscribe(observer).disposed(by: bag)

        expectationsAfterRequest(observer.events)

        mockAPI
            .pendingRequests
            .values
            .forEach { $0.1(.success(Data())) }

        expectationsAfterResponse(observer.events)
    }

    private func bothRequests(events: [Recorded<Event<ActionProtocol>>]) {
        XCTAssertEqual(2, events.count)
        XCTAssertTrue(
            (events[0].isWillRefreshRealTime && events[1].isWillRefreshHistoricalData) ||
            (events[1].isWillRefreshRealTime && events[0].isWillRefreshHistoricalData)
        )
    }

    private func realtimeRequest(events: [Recorded<Event<ActionProtocol>>]) {
        XCTAssertEqual(1, events.count)
        XCTAssertTrue(events[0].isWillRefreshRealTime)
    }

    private func historicalRequest(events: [Recorded<Event<ActionProtocol>>]) {
        XCTAssertEqual(1, events.count)
        XCTAssertTrue(events[0].isWillRefreshHistoricalData)
    }

    private func bothResponses(events: [Recorded<Event<ActionProtocol>>]) {
        XCTAssertEqual(5, events.count)
        XCTAssertTrue(
            (events[0].isWillRefreshRealTime && events[1].isWillRefreshHistoricalData) ||
            (events[1].isWillRefreshRealTime && events[0].isWillRefreshHistoricalData)
        )
        XCTAssertTrue(
            (events[2].isDidRefreshRealTime && events[3].isDidRefreshHistoricalData) ||
            (events[3].isDidRefreshRealTime && events[2].isDidRefreshHistoricalData)
        )
        XCTAssertTrue(events[4].isCompleted)
    }

    private func realtimeResponse(events: [Recorded<Event<ActionProtocol>>]) {
        XCTAssertEqual(3, events.count)
        XCTAssertTrue(events[0].isWillRefreshRealTime)
        XCTAssertTrue(events[1].isDidRefreshRealTime)
        XCTAssertTrue(events[2].isCompleted)
    }

    private func historicalResponse(events: [Recorded<Event<ActionProtocol>>]) {
        XCTAssertEqual(3, events.count)
        XCTAssertTrue(events[0].isWillRefreshHistoricalData)
        XCTAssertTrue(events[1].isDidRefreshHistoricalData)
        XCTAssertTrue(events[2].isCompleted)
    }

    private func empty(events: [Recorded<Event<ActionProtocol>>]) {
        XCTAssertEqual(1, events.count)
        XCTAssertTrue(events[0].isCompleted)
    }
}

extension Recorded where Value == Event<ActionProtocol> {
    fileprivate var isWillRefreshRealTime: Bool {
        guard case BitcoinRateAction.willRefreshRealTime? = value.element else {
            return false
        }
        return true
    }

    fileprivate var isWillRefreshHistoricalData: Bool {
        guard case BitcoinRateAction.willRefreshHistoricalData? = value.element else {
            return false
        }
        return true
    }

    fileprivate var isDidRefreshRealTime: Bool {
        guard case BitcoinRateAction.didRefreshRealTime? = value.element else {
            return false
        }
        return true
    }

    fileprivate var isDidRefreshHistoricalData: Bool {
        guard case BitcoinRateAction.didRefreshHistoricalData? = value.element else {
            return false
        }
        return true
    }

    fileprivate var isCompleted: Bool {
        guard case .completed = value else {
            return false
        }
        return true
    }
}
