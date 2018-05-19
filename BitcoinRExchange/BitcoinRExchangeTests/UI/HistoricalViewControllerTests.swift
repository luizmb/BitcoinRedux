@testable import BitcoinLibrary
@testable import BitcoinRExchange
@testable import CommonLibrary
import RxSwift
import SwiftRex
import UIKit
import XCTest

class HistoricalViewControllerTests: UnitTest {
    let mockAPIResponse = MockAPIResponse()

    override func setUp() {
        super.setUp()
        let store = BitcoinStore()

        injector.mapper.mapSingleton(BitcoinRateAPI.self) { return self.mockAPIResponse }
        injector.mapper.mapSingleton(RepositoryProtocol.self) { return MockRepository() }
        injector.mapper.mapSingleton(EventHandler.self) { return store }
        injector.mapper.mapSingleton(BitcoinStateProvider.self) { store }
    }

    func testHistoricalViewControllerNoDataAvailable() {
        Theme.apply()
        let sut = HistoricalViewController.start()!
        _ = UINavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.tableView().isHidden)
        XCTAssertFalse(sut.noDataLine1Label().isHidden)
        XCTAssertEqual(sut.noDataLine1Label().text, "No data available")
        XCTAssertFalse(sut.noDataLine2Label().isHidden)
        XCTAssertEqual(sut.noDataLine2Label().text, "Please check your internet connection and tap the button below to refresh")
        XCTAssertFalse(sut.noDataRefreshButton().isHidden)
        XCTAssertEqual(sut.noDataRefreshButton().titleLabel?.text, "Refresh")
    }

    func testHistoricalViewController_DataLoadedBeforeVc() {
        Theme.apply()

        let bag = DisposeBag()
        let eventHandler: EventHandler = injector.mapper.getSingleton()!
        let stateProvider: BitcoinStateProvider = injector.mapper.getSingleton()!
        let hasData = expectation(description: "Data Loaded")
        var hasDataFulfilled = false
        stateProvider[\.bitcoinState].subscribe(onNext: { state in
            if case .loaded = state.realtimeRate {
                if !hasDataFulfilled {
                    // This is safe, no calls out of main thread
                    hasDataFulfilled = true
                    hasData.fulfill()
                }
            }
        }).disposed(by: bag)
        eventHandler.dispatch(BitcoinRateEvent.automaticRefresh)
        wait(for: [hasData], timeout: 5)

        let sut = HistoricalViewController.start()!

        _ = UINavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.tableView().isHidden)
        XCTAssertTrue(sut.noDataLine1Label().isHidden)
        XCTAssertTrue(sut.noDataLine2Label().isHidden)
        XCTAssertTrue(sut.noDataRefreshButton().isHidden)
        XCTAssertEqual(sut.tableView().numberOfSections, 2)
        XCTAssertEqual(sut.tableView().numberOfRows(inSection: 0), 1)
        XCTAssertEqual(sut.tableView().numberOfRows(inSection: 1), 14)
    }

    func testHistoricalViewController_DataLoadedAfterVc() {
        Theme.apply()
        let sut = HistoricalViewController.start()!
        _ = UINavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.tableView().isHidden)

        let bag = DisposeBag()
        let eventHandler: EventHandler = injector.mapper.getSingleton()!
        let stateProvider: BitcoinStateProvider = injector.mapper.getSingleton()!
        let hasData = expectation(description: "Data Loaded")
        var hasDataFulfilled = false
        stateProvider[\.bitcoinState].subscribe(onNext: { state in
            if case .loaded = state.realtimeRate {
                if !hasDataFulfilled {
                    // This is safe, no calls out of main thread
                    hasDataFulfilled = true
                    hasData.fulfill()
                }
            }
        }).disposed(by: bag)
        eventHandler.dispatch(BitcoinRateEvent.automaticRefresh)
        wait(for: [hasData], timeout: 5)

        DispatchQueue.main.async {
            // Give TableView one runloop cycle to refresh its datasource
            XCTAssertFalse(sut.tableView().isHidden)
            XCTAssertTrue(sut.noDataLine1Label().isHidden)
            XCTAssertTrue(sut.noDataLine2Label().isHidden)
            XCTAssertTrue(sut.noDataRefreshButton().isHidden)
            XCTAssertEqual(sut.tableView().numberOfSections, 2)
            XCTAssertEqual(sut.tableView().numberOfRows(inSection: 0), 1)
            XCTAssertEqual(sut.tableView().numberOfRows(inSection: 1), 14)
        }
    }
}

extension HistoricalViewController {
    func tableView() -> UITableView {
        return view
            .subviews
            .first(where: { $0 is UITableView }) as! UITableView
    }

    func noDataLine1Label() -> UILabel {
        return view
            .subviews
            .first(where: { $0.accessibilityLabel == "noDataLine1Label" }) as! UILabel
    }

    func noDataLine2Label() -> UILabel {
        return view
            .subviews
            .first(where: { $0.accessibilityLabel == "noDataLine2Label" }) as! UILabel
    }

    func noDataRefreshButton() -> UIButton {
        return view
            .subviews
            .first(where: { $0.accessibilityLabel == "noDataRefreshButton" }) as! UIButton
    }
}
