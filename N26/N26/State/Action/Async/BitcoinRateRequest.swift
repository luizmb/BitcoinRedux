//
//  BitcoinRateRequest.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

enum BitcoinRateRequest: AppActionAsync {
    case realtimeRefresh
    case historicalDataRefresh

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> ()) {
        switch self {
        case .realtimeRefresh:
            let state = getState()
            if case let .syncing(oldTask, _) = state.bitcoinState.realtimeRate {
                oldTask.cancel()
            }

            let task = bitcoinRateAPI.request(.realtime(currency: state.currency.code)) { result in
                // TODO: Save to file-system
                let realtime: Result<RealTimeResponse> = result.flatMap(JsonParser.decode)
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
                // TODO: Save to file-system
                let historical: Result<HistoricalResponse> = result.flatMap(JsonParser.decode)
                dispatch(BitcoinRateAction.didRefreshHistoricalData(historical))
            }
            dispatch(BitcoinRateAction.willRefreshHistoricalData(task))
        }
    }
}

extension BitcoinRateRequest: HasBitcoinRateAPI { }
