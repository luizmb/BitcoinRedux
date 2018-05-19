import BitcoinLibrary
import Foundation
import SwiftRex

private let entryPointReducer =
    routerReducer.lift(\GlobalState.applicationState)
        <> bitcoinRateReducer.lift(\GlobalState.bitcoinState)

private let entryPointMiddleware =
    BootstrapMiddleware().lift(\GlobalState.applicationState)
        <> NavigationMiddleware().lift(\GlobalState.applicationState)
        <> BitcoinRateCacheMiddleware().lift(\GlobalState.bitcoinState)
        <> BitcoinRateAPIMiddleware().lift(\GlobalState.bitcoinState)

extension BitcoinStore {
    public static let shared: BitcoinStore = {
        let global = BitcoinStore()
        return global
    }()

    convenience init() {
        self.init(initialState: GlobalState(),
                  reducer: entryPointReducer,
                  middleware: entryPointMiddleware)
    }
}
