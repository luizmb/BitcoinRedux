//
//  BitcoinRateReducer.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

public struct BitcoinRateReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let bitcoinRateAction = action as? BitcoinRateAction else { return currentState }

        var stateCopy = currentState

        switch bitcoinRateAction {
        case .willRefreshRealTime(let task):
            let oldResult = stateCopy.bitcoinState.realtimeRate.possibleResult()
            stateCopy.bitcoinState.realtimeRate = .syncing(task: task, oldValue: oldResult)
        case .willRefreshHistoricalData(let task):
            let oldResult = stateCopy.bitcoinState.historicalRates.possibleResult()
            stateCopy.bitcoinState.historicalRates = .syncing(task: task, oldValue: oldResult)
        case .didRefreshRealTime(let result):
            switch result {
            case .success(let response):
                guard let rate = response.bpi[stateCopy.currency] else {
                    // TODO: We haven't got the correct currency. Handle that properly
                    return currentState
                }
                let newValue = BitcoinRealTimeRate(currency: stateCopy.currency,
                                                   lastUpdate: response.updatedTime,
                                                   rate: rate)
                stateCopy.bitcoinState.realtimeRate = .loaded(.success(newValue))
            case .error(let error):
                let oldResult = stateCopy.bitcoinState.realtimeRate.possibleResult()
                // TODO: Proper error handling (e.g: put error message into the state)
                stateCopy.bitcoinState.realtimeRate = oldResult.map { .loaded($0) } ?? .loaded(.error(error))
            }
        case .didRefreshHistoricalData(let result):
            switch result {
            case .success(let response):
                let newValue = response.bpi.map {
                    BitcoinHistoricalRate(currency: stateCopy.currency,
                                          closedDate: $0.date,
                                          rate: $0.rate)
                }
                stateCopy.bitcoinState.historicalRates = .loaded(.success(newValue))
            case .error(let error):
                let oldResult = stateCopy.bitcoinState.historicalRates.possibleResult()
                // TODO: Proper error handling (e.g: put error message into the state)
                stateCopy.bitcoinState.historicalRates = oldResult.map { .loaded($0) } ?? .loaded(.error(error))
            }
        }

        return stateCopy
    }
}
