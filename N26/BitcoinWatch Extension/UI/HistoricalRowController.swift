//
//  HistoricalRowController.swift
//  BitcoinWatch Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import WatchKit
import BitcoinLibrary
import CommonLibrary

final class HistoricalRowController: NSObject {
    static let reuseIdentifier = "HistoricalRow"

    @IBOutlet var dateLabel: WKInterfaceLabel!
    @IBOutlet var rateLabel: WKInterfaceLabel!
}
