//
//  BitcoinRealTimeRate.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public struct BitcoinRealTimeRate {
    public var currency: Currency
    public var lastUpdate: Date
    public var rate: Float

    public init(currency: Currency, lastUpdate: Date, rate: Float) {
        self.currency = currency
        self.lastUpdate = lastUpdate
        self.rate = rate
    }
}

extension BitcoinRealTimeRate: Equatable {
    public static func ==(lhs: BitcoinRealTimeRate, rhs: BitcoinRealTimeRate) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.lastUpdate == rhs.lastUpdate &&
            lhs.rate == rhs.rate
    }
}
