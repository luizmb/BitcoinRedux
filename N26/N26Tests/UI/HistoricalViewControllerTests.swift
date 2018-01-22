//
//  HistoricalViewController.swift
//  N26Tests
//
//  Created by Luiz Rodrigo Martins Barbosa on 22.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import XCTest
import UIKit
@testable import N26
@testable import BitcoinLibrary
@testable import CommonLibrary

class HistoricalViewControllerTests: UnitTest {
    let mockAPIResponse = MockAPIResponse()

    override func setUp() {
        super.setUp()
        Store.shared.currentState = AppState()
        // Mock
        injector.mapper.mapSingleton(BitcoinRateAPI.self) { return self.mockAPIResponse }
        injector.mapper.mapSingleton(RepositoryProtocol.self) { return MockRepository() }
        // Real
        injector.mapper.mapSingleton(ActionDispatcher.self) { return Store.shared }
        injector.mapper.mapSingleton(StateProvider.self) { Store.shared }
    }

    override func tearDown() {
        super.tearDown()
        Store.shared.currentState = AppState()
    }

    func testHistoricalViewControllerNoDataAvailable() {
        Theme.apply()
        let sut = HistoricalViewController.start()!
        _ = UINavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.tableView.isHidden)
        XCTAssertFalse(sut.noDataLine1Label.isHidden)
        XCTAssertEqual(sut.noDataLine1Label.text, "No data available")
        XCTAssertFalse(sut.noDataLine2Label.isHidden)
        XCTAssertEqual(sut.noDataLine2Label.text, "Please check your internet connection and tap the button below to refresh")
        XCTAssertFalse(sut.noDataRefreshButton.isHidden)
        XCTAssertEqual(sut.noDataRefreshButton.titleLabel?.text, "Refresh")
    }

    func testHistoricalViewController_DataLoadedBeforeVc() {
        Theme.apply()

        var bag: [Any] = []
        let store = Store.shared
        let hasData = expectation(description: "Data Loaded")
        var hasDataFulfilled = false
        store[\.bitcoinState].subscribe { state in
            if case .loaded = state.realtimeRate {
                if !hasDataFulfilled {
                    // This is safe, no calls out of main thread
                    hasDataFulfilled = true
                    hasData.fulfill()
                }
            }
        }.addDisposableTo(&bag)
        store.async(BitcoinRateRequest.realtimeRefresh(isManual: false))
        store.async(BitcoinRateRequest.historicalDataRefresh(isManual: false))
        wait(for: [hasData], timeout: 5)

        let sut = HistoricalViewController.start()!

        _ = UINavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.tableView.isHidden)
        XCTAssertTrue(sut.noDataLine1Label.isHidden)
        XCTAssertTrue(sut.noDataLine2Label.isHidden)
        XCTAssertTrue(sut.noDataRefreshButton.isHidden)
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 14)
    }

    func testHistoricalViewController_DataLoadedAfterVc() {
        Theme.apply()
        let sut = HistoricalViewController.start()!
        _ = UINavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.tableView.isHidden)

        var bag: [Any] = []
        let store = Store.shared
        let hasData = expectation(description: "Data Loaded")
        var hasDataFulfilled = false
        store[\.bitcoinState].subscribe { state in
            if case .loaded = state.realtimeRate {
                if !hasDataFulfilled {
                    // This is safe, no calls out of main thread
                    hasDataFulfilled = true
                    hasData.fulfill()
                }
            }
            }.addDisposableTo(&bag)
        store.async(BitcoinRateRequest.realtimeRefresh(isManual: false))
        store.async(BitcoinRateRequest.historicalDataRefresh(isManual: false))
        wait(for: [hasData], timeout: 5)

        DispatchQueue.main.async {
            // Give TableView one runloop cycle to refresh its datasource
            XCTAssertFalse(sut.tableView.isHidden)
            XCTAssertTrue(sut.noDataLine1Label.isHidden)
            XCTAssertTrue(sut.noDataLine2Label.isHidden)
            XCTAssertTrue(sut.noDataRefreshButton.isHidden)
            XCTAssertEqual(sut.tableView.numberOfSections, 2)
            XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
            XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 14)
        }
    }
}
