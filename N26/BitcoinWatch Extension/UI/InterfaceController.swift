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

final class InterfaceController: WKInterfaceController {
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
    }
}

extension InterfaceController: HasActionDispatcher { }
extension InterfaceController: HasStateProvider { }
extension InterfaceController: HasDisposableBag { }
