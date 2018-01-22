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
        DispatchQueue.main.async {
            if case let .loaded(result) = state.realtimeRate,
                case let .success(realtimeRate) = result {

                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short

                let numberFormatter = NumberFormatter()
                numberFormatter.currencyCode = realtimeRate.currency.code
                numberFormatter.currencySymbol = realtimeRate.currency.symbol
                numberFormatter.numberStyle = .currency

                self.realtimeDateLabel.setText(dateFormatter.string(from: realtimeRate.lastUpdate))
                self.realtimeRateLabel.setText(numberFormatter.string(from: NSDecimalNumber(value: realtimeRate.rate)) ?? "")
            }

            if case let .loaded(result) = state.historicalRates,
                case let .success(historicalRate) = result {
                self.historicalTable.setNumberOfRows(historicalRate.count,
                                                withRowType: HistoricalRowController.reuseIdentifier)

//                let dateFormatter = DateFormatter()
//                dateFormatter.dateStyle = .short
//                dateFormatter.timeStyle = .none

                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency

                for index in 0..<self.historicalTable.numberOfRows {
                    guard let controller = self.historicalTable.rowController(at: index) as? HistoricalRowController else { continue }
                    numberFormatter.currencyCode = historicalRate[index].currency.code
                    numberFormatter.currencySymbol = historicalRate[index].currency.symbol
                    let dateText = historicalRate[index].closedDate
                        .formattedFromComponents(styleAttitude: .short, year: false, month: true, day: true,
                                                 hour: false, minute: false, second: false, locale: Locale.current)
                    let rateText = numberFormatter.string(from: NSDecimalNumber(value: historicalRate[index].rate))
                    controller.dateLabel.setText(dateText)
                    controller.rateLabel.setText(rateText)
                }
            }
        }
    }

    @IBAction func refreshMenuItemTap() {
        actionDispatcher.async(BitcoinRateRequest.realtimeRefresh(isManual: true))
        actionDispatcher.async(BitcoinRateRequest.historicalDataRefresh(isManual: true))
    }
}

extension HistoricalInterfaceController: HasActionDispatcher { }
extension HistoricalInterfaceController: HasStateProvider { }
extension HistoricalInterfaceController: HasDisposableBag { }
