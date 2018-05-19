import CommonLibrary
import Foundation
import SwiftRex

public let bitcoinRateReducer = Reducer<BitcoinState> { state, action in
    guard let bitcoinRateAction = action as? BitcoinRateAction else { return state }

    var bitcoinState = state

    switch bitcoinRateAction {
    case .willRefreshRealTime(let task):
        let oldResult = bitcoinState.realtimeRate.possibleResult()
        bitcoinState.realtimeRate = .syncing(task: task, oldValue: oldResult)
        bitcoinState.localTimeLastUpdateRealTime = Date()
    case .willRefreshHistoricalData(let task):
        let oldResult = bitcoinState.historicalRates.possibleResult()
        bitcoinState.historicalRates = .syncing(task: task, oldValue: oldResult)
        bitcoinState.localTimeLastUpdateHistorical = Date()
    case .didRefreshRealTime(let result):
        switch result {
        case .success(let response):
            guard let rate = response.bpi[bitcoinState.currency] else {
                // TODO: We haven't got the correct currency. Handle that properly
                return state
            }
            let newValue = BitcoinRealTimeRate(currency: bitcoinState.currency,
                                               lastUpdate: response.updatedTime,
                                               rate: rate)
            bitcoinState.realtimeRate = .loaded(.success(newValue))
        case .error(let error):
            let oldResult = bitcoinState.realtimeRate.possibleResult()
            // TODO: Proper error handling (e.g: put error message into the state)
            bitcoinState.realtimeRate = oldResult.map { .loaded($0) } ?? .loaded(.error(error))
            bitcoinState.localTimeLastUpdateRealTime = Date.distantPast
        }
    case .didRefreshHistoricalData(let result):
        switch result {
        case .success(let response):
            let newValue = response.bpi.map {
                BitcoinHistoricalRate(currency: bitcoinState.currency,
                                      closedDate: $0.date,
                                      rate: $0.rate)
            }
            bitcoinState.historicalRates = .loaded(.success(newValue))
        case .error(let error):
            let oldResult = bitcoinState.historicalRates.possibleResult()
            // TODO: Proper error handling (e.g: put error message into the state)
            bitcoinState.historicalRates = oldResult.map { .loaded($0) } ?? .loaded(.error(error))
            bitcoinState.localTimeLastUpdateHistorical = Date.distantPast
        }
    }

    return bitcoinState
}
