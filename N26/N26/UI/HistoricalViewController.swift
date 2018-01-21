//
//  HistoricalViewController.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit
import BitcoinLibrary
import CommonLibrary

final class HistoricalViewController: UIViewController {
    var disposables: [Any] = []
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var dataSource: HistoricalDataSource!
    @IBOutlet weak var noDataLine1Label: UILabel!
    @IBOutlet weak var noDataLine2Label: UILabel!
    @IBOutlet weak var noDataRefreshButton: UIButton!
    
    override func viewDidLoad() {
        self.title = "Bitcoin Rates"
        dataSource = HistoricalDataSource(tableView: tableView)
        stateProvider[\.bitcoinState].subscribe { [weak self] state in
            self?.update(state: state)
        }.bind(to: self)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }

    private func update(state: BitcoinState) {
        DispatchQueue.main.async {
            var sections: [HistoricalTableViewSection] = []

            if let realtimeSection = state.realtimeRate.possibleValue().flatMap(HistoricalTableViewSection.init) {
                sections.append(realtimeSection)
            }

            if let historicalSection = state.historicalRates.possibleValue().flatMap(HistoricalTableViewSection.init) {
                sections.append(historicalSection)
            }

            self.dataSource.viewModel = sections
            if sections.count == 0 {
                self.tableView.isHidden = true
                self.noDataLine1Label.isHidden = false
                self.noDataLine2Label.isHidden = false
                self.noDataRefreshButton.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.noDataLine1Label.isHidden = true
                self.noDataLine2Label.isHidden = true
                self.noDataRefreshButton.isHidden = true
            }

            switch (state.realtimeRate, state.historicalRates) {
            case (.syncing, _), (_, .syncing): return
            default: self.refreshControl.endRefreshing()
            }
        }
    }

    @IBAction func refreshButtonTap(_ sender: Any) {
        actionDispatcher.async(BitcoinRateRequest.realtimeRefresh(isManual: true))
        actionDispatcher.async(BitcoinRateRequest.historicalDataRefresh(isManual: true))
    }

    @objc private func pullToRefresh() {
        actionDispatcher.async(BitcoinRateRequest.realtimeRefresh(isManual: true))
        actionDispatcher.async(BitcoinRateRequest.historicalDataRefresh(isManual: true))
    }
}

extension HistoricalViewController: HasActionDispatcher { }
extension HistoricalViewController: HasStateProvider { }
extension HistoricalViewController: Startable { }
extension HistoricalViewController: HasDisposableBag { }
