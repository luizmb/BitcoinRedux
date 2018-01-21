//
//  InterfaceController.swift
//  BitcoinWatch Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import WatchKit
import BitcoinLibrary
import CommonLibrary

final class HistoricalInterfaceController: WKInterfaceController {
    var disposables: [Any] = []

    @IBOutlet var realtimeDateLabel: WKInterfaceLabel!
    @IBOutlet var realtimeRateLabel: WKInterfaceLabel!
    @IBOutlet var historicalTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.setTitle("Bitcoin Rates")

        stateProvider[\.bitcoinState].subscribe { [weak self] state in
            self?.update(state: state)
        }.bind(to: self)
    }

    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    private func update(state: BitcoinState) {

        if case let .loaded(result) = state.realtimeRate,
            case let .success(realtimeRate) = result {

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short

            let numberFormatter = NumberFormatter()
            numberFormatter.currencyCode = realtimeRate.currency.code
            numberFormatter.currencySymbol = realtimeRate.currency.symbol
            numberFormatter.numberStyle = .currency

            realtimeDateLabel.setText(dateFormatter.string(from: realtimeRate.lastUpdate))
            realtimeRateLabel.setText(numberFormatter.string(from: NSDecimalNumber(value: realtimeRate.rate)) ?? "")
        }

        if case let .loaded(result) = state.historicalRates,
            case let .success(historicalRate) = result {
            historicalTable.setNumberOfRows(historicalRate.count,
                                            withRowType: HistoricalRowController.reuseIdentifier)

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency

            for index in 0..<historicalTable.numberOfRows {
                guard let controller = historicalTable.rowController(at: index) as? HistoricalRowController else { continue }
                numberFormatter.currencyCode = historicalRate[index].currency.code
                numberFormatter.currencySymbol = historicalRate[index].currency.symbol
                let dateText = dateFormatter.string(from: historicalRate[index].closedDate)
                let rateText = numberFormatter.string(from: NSDecimalNumber(value: historicalRate[index].rate))
                controller.dateLabel.setText(dateText)
                controller.rateLabel.setText(rateText)
            }
        }
    }
}

extension HistoricalInterfaceController: HasActionDispatcher { }
extension HistoricalInterfaceController: HasStateProvider { }
extension HistoricalInterfaceController: HasDisposableBag { }