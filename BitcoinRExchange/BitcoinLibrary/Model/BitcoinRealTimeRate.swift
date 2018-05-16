import Foundation

public struct BitcoinRealTimeRate: Equatable {
    public var currency: Currency
    public var lastUpdate: Date
    public var rate: Float

    public init(currency: Currency, lastUpdate: Date, rate: Float) {
        self.currency = currency
        self.lastUpdate = lastUpdate
        self.rate = rate
    }
}
