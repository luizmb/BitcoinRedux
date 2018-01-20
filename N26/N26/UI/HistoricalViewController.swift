//
//  HistoricalViewController.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit

final class HistoricalViewController: UIViewController {
    var disposables: [Any] = []
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: HistoricalDataSource!

    override func viewDidLoad() {
        self.title = "Bitcoin Rates"
        dataSource = HistoricalDataSource(tableView: tableView)
        stateProvider[\.bitcoinState].subscribe { [weak self] state in
            self?.update(state: state)
        }.bind(to: self)
    }

    private func update(state: BitcoinState) {
        var sections: [HistoricalTableViewSection] = []

        if let realtimeSection = state.realtimeRate.possibleValue().flatMap(HistoricalTableViewSection.init) {
            sections.append(realtimeSection)
        }

        if let historicalSection = state.historicalRates.possibleValue().flatMap(HistoricalTableViewSection.init) {
            sections.append(historicalSection)
        }

        dataSource.viewModel = sections
        if sections.count < 0 {
            // TODO: Fallback for no results
        }
    }
}

extension HistoricalViewController: HasActionDispatcher { }
extension HistoricalViewController: HasStateProvider { }
extension HistoricalViewController: Startable { }
extension HistoricalViewController: HasDisposableBag { }
