//
//  BitcoinRatesState.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public struct BitcoinState {
    public var realtimeRate: BitcoinRealTimeRate = BitcoinRealTimeRate()
    public var historicalRates: [BitcoinHistoricalRate] = []
}

extension BitcoinState: Equatable {
    public static func ==(lhs: BitcoinState, rhs: BitcoinState) -> Bool {
        return lhs.realtimeRate == rhs.realtimeRate &&
            lhs.historicalRates == rhs.historicalRates
    }
}
