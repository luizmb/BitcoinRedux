import Foundation
import CommonLibrary

public enum BitcoinRateAction: Action {
    case willRefreshRealTime(CancelableTask)
    case willRefreshHistoricalData(CancelableTask)
    case didRefreshRealTime(Result<RealTimeResponse>)
    case didRefreshHistoricalData(Result<HistoricalResponse>)
}
