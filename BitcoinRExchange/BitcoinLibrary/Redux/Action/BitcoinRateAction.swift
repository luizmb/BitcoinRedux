import CommonLibrary
import Foundation
import SwiftRex

public enum BitcoinRateAction: ActionProtocol {
    case willRefreshRealTime(CancelableTask)
    case willRefreshHistoricalData(CancelableTask)
    case didRefreshRealTime(Result<RealTimeResponse>)
    case didRefreshHistoricalData(Result<HistoricalResponse>)
}
