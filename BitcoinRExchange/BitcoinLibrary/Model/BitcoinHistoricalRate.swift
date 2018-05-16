import Foundation

public struct BitcoinHistoricalRate: Equatable {
    public var currency: Currency
    public var closedDate: Date
    public var rate: Float

    public init(currency: Currency, closedDate: Date, rate: Float) {
        self.currency = currency
        self.closedDate = closedDate
        self.rate = rate
    }
}
