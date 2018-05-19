import CommonLibrary
import Foundation
import RxSwift
import SwiftRex

public class BitcoinRateAPISideEffect: SideEffectProducer {
    public typealias StateType = BitcoinState
    private let event: BitcoinRateEvent

    public init(event: BitcoinRateEvent) {
        self.event = event
    }

    public func execute(getState: @escaping () -> BitcoinState) -> Observable<ActionProtocol> {
        let state = getState()

        var streams: [Observable<ActionProtocol>] = []

        switch event {
        case .manualRefresh:
            streams = [updateRealTime(state: state), updateHistorical(state: state)]
        case .automaticRefresh, .setup:
            if shouldAutoUpdate(last: state.localTimeLastUpdateRealTime,
                                interval: state.realtimeRateRefreshTime) {
                streams.append(updateRealTime(state: state))
            }

            if shouldAutoUpdate(last: state.localTimeLastUpdateHistorical,
                                interval: state.historicalRatesRefreshTime) {
                streams.append(updateHistorical(state: state))
            }
        }

        return Observable<ActionProtocol>.merge(streams)
    }

    private func updateRealTime(state: BitcoinState) -> Observable<ActionProtocol> {
        return Observable.create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }

            if case let .syncing(oldTask, _) = state.realtimeRate {
                oldTask.cancel()
            }

            let task = strongSelf.bitcoinRateAPI.request(.realtime(currency: state.currency.code)) { result in
                let realtime: Result<RealTimeResponse> = result.flatMap { data in
                    strongSelf.repository.save(data: data, filename: RealTimeResponse.cacheFile)
                    return JsonParser.decode(data)
                }

                observer.on(.next(BitcoinRateAction.didRefreshRealTime(realtime)))
                observer.on(.completed)
            }

            observer.on(.next(BitcoinRateAction.willRefreshRealTime(task)))

            return Disposables.create {
                task.cancel()
            }
        }
    }

    private func updateHistorical(state: BitcoinState) -> Observable<ActionProtocol> {
        return Observable.create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }

            if case let .syncing(oldTask, _) = state.historicalRates {
                oldTask.cancel()
            }

            let startDate = Date().backToMidnight.addingDays(-state.historicalDays)
            let task = strongSelf.bitcoinRateAPI.request(.historical(currency: state.currency.code,
                                                                     startDate: startDate,
                                                                     endDate: Date() )) { result in
                let historical: Result<HistoricalResponse> = result.flatMap { data in
                    strongSelf.repository.save(data: data, filename: HistoricalResponse.cacheFile)
                    return JsonParser.decode(data)
                }

                observer.on(.next(BitcoinRateAction.didRefreshHistoricalData(historical)))
                observer.on(.completed)
            }

            observer.on(.next(BitcoinRateAction.willRefreshHistoricalData(task)))

            return Disposables.create {
                task.cancel()
            }
        }
    }

    private func shouldAutoUpdate(last: Date, interval: TimeInterval) -> Bool {
        let nextUpdate = last.addingTimeInterval(interval)
        return Date() > nextUpdate
    }
}

extension BitcoinRateAPISideEffect: HasBitcoinRateAPI { }
extension BitcoinRateAPISideEffect: HasRepository { }
