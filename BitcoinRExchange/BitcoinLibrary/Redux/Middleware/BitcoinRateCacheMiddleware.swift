import CommonLibrary
import Foundation
import RxSwift
import SwiftRex

public class BitcoinRateCacheMiddleware: Middleware {
    public var actionHandler: ActionHandler?

    public func handle(event: EventProtocol,
                       getState: @escaping () -> BitcoinState,
                       next: @escaping (EventProtocol, @escaping () -> BitcoinState) -> Void) {

        if let appEvent = event as? BitcoinRateEvent, case .setup = appEvent {
            let realtime: Result<RealTimeResponse> =
                repository.load(filename: RealTimeResponse.cacheFile).flatMap(JsonParser.decode)
            let historical: Result<HistoricalResponse> =
                repository.load(filename: HistoricalResponse.cacheFile).flatMap(JsonParser.decode)

            actionHandler?.trigger(BitcoinRateAction.didRefreshRealTime(realtime))
            actionHandler?.trigger(BitcoinRateAction.didRefreshHistoricalData(historical))
        }

        next(event, getState)
    }

    public func handle(action: ActionProtocol,
                       getState: @escaping () -> BitcoinState,
                       next: @escaping (ActionProtocol, @escaping () -> BitcoinState) -> Void) {
        next(action, getState)
    }

    public init() { }
}

extension BitcoinRateCacheMiddleware: HasRepository { }
