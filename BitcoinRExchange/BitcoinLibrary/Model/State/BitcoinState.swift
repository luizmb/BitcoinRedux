import CommonLibrary
import Foundation

public struct BitcoinState {
    public var realtimeRate: SyncableResult<BitcoinRealTimeRate> = .neverLoaded
    public var historicalRates: SyncableArrayResult<BitcoinHistoricalRate> = .neverLoaded
    public var localTimeLastUpdateRealTime = Date.distantPast
    public var localTimeLastUpdateHistorical = Date.distantPast
    public var realtimeRateRefreshTime: TimeInterval = 60
    public var historicalRatesRefreshTime: TimeInterval = 60 * 60 * 6
}

extension BitcoinState: Equatable {
    public static func == (lhs: BitcoinState, rhs: BitcoinState) -> Bool {
        return lhs.realtimeRate == rhs.realtimeRate &&
            lhs.historicalRates == rhs.historicalRates &&
            lhs.localTimeLastUpdateRealTime == rhs.localTimeLastUpdateRealTime &&
            lhs.localTimeLastUpdateHistorical == rhs.localTimeLastUpdateHistorical &&
            lhs.realtimeRateRefreshTime == rhs.realtimeRateRefreshTime &&
            lhs.historicalRatesRefreshTime == rhs.historicalRatesRefreshTime
    }
}
