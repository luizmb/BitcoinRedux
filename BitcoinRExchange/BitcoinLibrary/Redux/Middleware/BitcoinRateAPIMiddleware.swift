import CommonLibrary
import Foundation
import RxSwift
import SwiftRex

public class BitcoinRateAPIMiddleware: SideEffectMiddleware {
    public typealias StateType = BitcoinState
    public var actionHandler: ActionHandler?
    public var allowEventToPropagate = true
    public var disposeBag = DisposeBag()

    public func sideEffect(for event: EventProtocol) -> AnySideEffectProducer<BitcoinState>? {
        guard let bitcoinRateEvent = event as? BitcoinRateEvent else { return nil }

        return AnySideEffectProducer(BitcoinRateAPISideEffect(event: bitcoinRateEvent))
    }

    public init() { }
}
