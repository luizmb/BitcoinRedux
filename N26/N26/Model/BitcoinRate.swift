//
//  BitcoinRate.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public struct BitcoinRealTimeRate {
    var currency: Currency
    var lastUpdate: Date
    var rate: Float
}

public struct BitcoinHistoricalRate {
    var currency: Currency
    var closedDate: Date
    var rate: Float
}

extension BitcoinRealTimeRate: Equatable {
    public static func ==(lhs: BitcoinRealTimeRate, rhs: BitcoinRealTimeRate) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.lastUpdate == rhs.lastUpdate &&
            lhs.rate == rhs.rate
    }
}

extension BitcoinHistoricalRate: Equatable {
    public static func ==(lhs: BitcoinHistoricalRate, rhs: BitcoinHistoricalRate) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.closedDate == rhs.closedDate &&
            lhs.rate == rhs.rate
    }
}
