import CommonLibrary
import Foundation

public enum BitcoinRateRequest: AppActionAsync {
    case realtimeCache
    case historicalCache
    case realtimeRefresh(isManual: Bool)
    case historicalDataRefresh(isManual: Bool)

    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .realtimeCache:
            let realtime: Result<RealTimeResponse> = self.repository.load(filename: RealTimeResponse.cacheFile).flatMap(JsonParser.decode)
            dispatch(BitcoinRateAction.didRefreshRealTime(realtime))
        case .historicalCache:
            let historical: Result<HistoricalResponse> = self.repository.load(filename: HistoricalResponse.cacheFile).flatMap(JsonParser.decode)
            dispatch(BitcoinRateAction.didRefreshHistoricalData(historical))
        case .realtimeRefresh(let isManual):
            let state = getState()
            let lastUpdate = state.bitcoinState.localTimeLastUpdateRealTime
            let refreshTime = state.bitcoinState.realtimeRateRefreshTime
            let nextUpdate = lastUpdate.addingTimeInterval(refreshTime)
            guard isManual || Date() > nextUpdate else { return }

            if case let .syncing(oldTask, _) = state.bitcoinState.realtimeRate {
                oldTask.cancel()
            }

            let task = bitcoinRateAPI.request(.realtime(currency: state.currency.code)) { result in
                let realtime: Result<RealTimeResponse> = result.flatMap { data in
                    self.repository.save(data: data, filename: RealTimeResponse.cacheFile)
                    return JsonParser.decode(data)
                }
                dispatch(BitcoinRateAction.didRefreshRealTime(realtime))
            }
            debugPrint("Refresh RealTime rates")
            dispatch(BitcoinRateAction.willRefreshRealTime(task))
        case .historicalDataRefresh(let isManual):
            let state = getState()
            let lastUpdate = state.bitcoinState.localTimeLastUpdateHistorical
            let refreshTime = state.bitcoinState.historicalRatesRefreshTime
            let nextUpdate = lastUpdate.addingTimeInterval(refreshTime)
            guard isManual || Date() > nextUpdate else { return }

            if case let .syncing(oldTask, _) = state.bitcoinState.historicalRates {
                oldTask.cancel()
            }

            let startDate = Date().backToMidnight.addingDays(-state.historicalDays)
            let task = bitcoinRateAPI.request(.historical(currency: state.currency.code, startDate: startDate, endDate: Date() )) { result in
                let historical: Result<HistoricalResponse> = result.flatMap { data in
                    self.repository.save(data: data, filename: HistoricalResponse.cacheFile)
                    return JsonParser.decode(data)
                }
                dispatch(BitcoinRateAction.didRefreshHistoricalData(historical))
            }
            debugPrint("Refresh Historical rates")
            dispatch(BitcoinRateAction.willRefreshHistoricalData(task))
        }
    }
}

extension BitcoinRateRequest: HasBitcoinRateAPI { }
extension BitcoinRateRequest: HasRepository { }
