//
//  InterfaceController.swift
//  BitcoinWatch Extension
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var realtimeDateLabel: WKInterfaceLabel!
    @IBOutlet var realtimeRateLabel: WKInterfaceLabel!

    @IBOutlet var historicalTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        super.willActivate()

        self.realtimeDateLabel.setText("99/99 99:99:99")
        self.realtimeRateLabel.setText("9.999.999,9999")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
