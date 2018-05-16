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
    public static func == (lhs: BitcoinRealTimeRate, rhs: BitcoinRealTimeRate) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.lastUpdate == rhs.lastUpdate &&
            lhs.rate == rhs.rate
    }
}
