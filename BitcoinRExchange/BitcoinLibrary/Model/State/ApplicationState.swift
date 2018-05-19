#if os(iOS)
import UIKit
#endif
import CommonLibrary

public struct ApplicationState: Equatable {
    public var navigation = NavigationState.still(at: .root())
    public weak var application: Application?
    #if os(iOS)
    public weak var navigationController: UINavigationController?
    #endif

    public init() { }
}

extension ApplicationState {
    public static func == (lhs: ApplicationState, rhs: ApplicationState) -> Bool {
        return lhs.navigation == rhs.navigation
    }
}
