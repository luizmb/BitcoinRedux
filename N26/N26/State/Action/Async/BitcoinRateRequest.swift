//
//  BitcoinRateRequest.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

enum BitcoinRateRequest: AppActionAsync {
    case realtimeCache
    case historicalCache
    case realtimeRefresh
    case historicalDataRefresh

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> ()) {
        switch self {
        case .realtimeCache:
            let realtime: Result<RealTimeResponse> = self.repository.load(name: RealTimeResponse.cacheFile).flatMap(JsonParser.decode)
            dispatch(BitcoinRateAction.didRefreshRealTime(realtime))
        case .historicalCache:
            let historical: Result<HistoricalResponse> = self.repository.load(name: HistoricalResponse.cacheFile).flatMap(JsonParser.decode)
            dispatch(BitcoinRateAction.didRefreshHistoricalData(historical))
        case .realtimeRefresh:
            let state = getState()
            if case let .syncing(oldTask, _) = state.bitcoinState.realtimeRate {
                oldTask.cancel()
            }

            let task = bitcoinRateAPI.request(.realtime(currency: state.currency.code)) { result in
                let realtime: Result<RealTimeResponse> = result.flatMap { data in
                    self.repository.save(data: data, name: RealTimeResponse.cacheFile)
                    return JsonParser.decode(data)
                }
                dispatch(BitcoinRateAction.didRefreshRealTime(realtime))
            }
            dispatch(BitcoinRateAction.willRefreshRealTime(task))
        case .historicalDataRefresh:
            let state = getState()
            if case let .syncing(oldTask, _) = state.bitcoinState.historicalRates {
                oldTask.cancel()
            }

            let startDate = Date().backToMidnight.addingDays(-state.historicalDays)
            let task = bitcoinRateAPI.request(.historical(currency: state.currency.code, startDate: startDate, endDate: Date() )) { result in
                let historical: Result<HistoricalResponse> = result.flatMap { data in
                    self.repository.save(data: data, name: HistoricalResponse.cacheFile)
                    return JsonParser.decode(data)
                }
                dispatch(BitcoinRateAction.didRefreshHistoricalData(historical))
            }
            dispatch(BitcoinRateAction.willRefreshHistoricalData(task))
        }
    }
}

extension BitcoinRateRequest: HasBitcoinRateAPI { }
extension BitcoinRateRequest: HasRepository { }
