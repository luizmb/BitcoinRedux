//
//  HistoricalViewModel.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import BitcoinLibrary

struct HistoricalViewModel {
    let sections: [HistoricalTableViewSection]?
}

struct HistoricalTableViewSection {
    let title: String
    let rows: [HistoricalTableViewRow]
}

struct HistoricalTableViewRow {
    let date: String
    let rate: String
}

extension HistoricalTableViewSection {
    init(_ state: BitcoinRealTimeRate) {
        self.title = "Real-time rate"
        self.rows = [state].map(HistoricalTableViewRow.init)
    }

    init(_ state: [BitcoinHistoricalRate]) {
        self.title = "Historical rates"
        self.rows = state.map(HistoricalTableViewRow.init)
    }
}

extension HistoricalTableViewRow {
    init(_ state: BitcoinRealTimeRate) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = state.currency.code
        numberFormatter.currencySymbol = state.currency.symbol
        numberFormatter.numberStyle = .currency

        self.date = dateFormatter.string(from: state.lastUpdate)
        self.rate = numberFormatter.string(from: NSDecimalNumber(value: state.rate)) ?? ""
    }

    init(_ state: BitcoinHistoricalRate) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = state.currency.code
        numberFormatter.currencySymbol = state.currency.symbol
        numberFormatter.numberStyle = .currency

        self.date = dateFormatter.string(from: state.closedDate)
        self.rate = numberFormatter.string(from: NSDecimalNumber(value: state.rate)) ?? ""
    }
}
