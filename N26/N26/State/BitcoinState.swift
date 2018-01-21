//
//  BitcoinRatesState.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import BitcoinLibrary
import CommonLibrary

public struct BitcoinState {
    public var realtimeRate: SyncableResult<BitcoinRealTimeRate> = .neverLoaded
    public var historicalRates: SyncableArrayResult<BitcoinHistoricalRate> = .neverLoaded
}

extension BitcoinState: Equatable {
    public static func ==(lhs: BitcoinState, rhs: BitcoinState) -> Bool {
        return lhs.realtimeRate == rhs.realtimeRate &&
            lhs.historicalRates == rhs.historicalRates
    }
}
