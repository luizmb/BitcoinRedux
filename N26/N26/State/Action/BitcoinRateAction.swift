//
//  BitcoinRateAction.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public enum BitcoinRateAction: Action {
    case willRefreshRealTime(CancelableTask)
    case willRefreshHistoricalData(CancelableTask)
    case didRefreshRealTime(Result<RealTimeResponse>)
    case didRefreshHistoricalData(Result<HistoricalResponse>)
}
