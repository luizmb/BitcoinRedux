#if os(iOS)
import UIKit
#endif
import CommonLibrary

public struct AppState: Equatable {
    public var bitcoinState = BitcoinState()
    public var currency = Currency(code: "EUR", name: "Euro", symbol: "€")
    public var historicalDays = 14

    public var navigation = NavigationState.still(at: .root())
    public weak var application: Application?
    #if os(iOS)
    public weak var navigationController: UINavigationController?
    #endif

    public init() { }
}

extension AppState {
    public static func == (lhs: AppState, rhs: AppState) -> Bool {
        return
            lhs.bitcoinState == rhs.bitcoinState &&
            lhs.currency == rhs.currency &&
            lhs.historicalDays == rhs.historicalDays &&
            lhs.navigation == rhs.navigation
    }
}
