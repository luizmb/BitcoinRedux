import CommonLibrary
import Foundation

public struct BitcoinState: Equatable {
    public var realtimeRate: SyncableResult<BitcoinRealTimeRate> = .neverLoaded
    public var historicalRates: SyncableResult<[BitcoinHistoricalRate]> = .neverLoaded
    public var localTimeLastUpdateRealTime = Date.distantPast
    public var localTimeLastUpdateHistorical = Date.distantPast
    public var currency = Currency(code: "EUR", name: "Euro", symbol: "€")
    public var historicalDays = 14
    public var realtimeRateRefreshTime: TimeInterval = 60
    public var historicalRatesRefreshTime: TimeInterval = 60 * 60 * 6
}
