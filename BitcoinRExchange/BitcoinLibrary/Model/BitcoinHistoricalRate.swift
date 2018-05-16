import Foundation

public struct BitcoinHistoricalRate {
    public var currency: Currency
    public var closedDate: Date
    public var rate: Float

    public init(currency: Currency, closedDate: Date, rate: Float) {
        self.currency = currency
        self.closedDate = closedDate
        self.rate = rate
    }
}

extension BitcoinHistoricalRate: Equatable {
    public static func == (lhs: BitcoinHistoricalRate, rhs: BitcoinHistoricalRate) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.closedDate == rhs.closedDate &&
            lhs.rate == rhs.rate
    }
}
