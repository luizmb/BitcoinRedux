//
//  HistoricalDataSource.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import UIKit
import CommonLibrary

final class HistoricalDataSource: NSObject, UITableViewDataSource {
    private weak var tableView: UITableView?

    var viewModel: [HistoricalTableViewSection] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }

    required init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.register(HistoricalRecordTableViewCell.nib(),
                                 forCellReuseIdentifier: HistoricalRecordTableViewCell.reuseIdentifier())
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel[safe: section]?.title ?? ""
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[safe: section]?.rows.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoricalRecordTableViewCell.reuseIdentifier(),
                                                 for: indexPath)

        guard let historicalRecordTableViewCell = cell as? HistoricalRecordTableViewCell,
            let cellModel = viewModel[safe: indexPath.section]?.rows[safe: indexPath.row] else {
            return cell
        }

        historicalRecordTableViewCell.dateLabel.text = cellModel.date
        historicalRecordTableViewCell.rateLabel.text = cellModel.rate
        return historicalRecordTableViewCell
    }
}

extension HistoricalDataSource: HasActionDispatcher { }
extension HistoricalDataSource: HasStateProvider { }
