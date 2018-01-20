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
        dataSource = HistoricalDataSource(tableView: tableView)
        stateProvider[\.bitcoinState].subscribe { [weak self] state in
            self?.update(state: state)
        }.bind(to: self)
    }

    private func update(state: BitcoinState) {
        let sections = [HistoricalTableViewSection(state.realtimeRate),
                        HistoricalTableViewSection(state.historicalRates)]
        dataSource.viewModel = sections
    }
}

extension HistoricalViewController: HasActionDispatcher { }
extension HistoricalViewController: HasStateProvider { }
extension HistoricalViewController: Startable { }
extension HistoricalViewController: HasDisposableBag { }
