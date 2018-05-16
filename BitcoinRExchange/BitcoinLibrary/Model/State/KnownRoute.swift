#if os(iOS)
import UIKit
#endif

public protocol KnownRoute {
    var route: NavigationRoute { get }
    #if os(iOS)
    func navigate(_ navigationController: UINavigationController, completion: @escaping () -> Void)
    #else
    func navigate(completion: @escaping () -> Void)
    #endif
}

public func == (lhs: KnownRoute, rhs: KnownRoute) -> Bool {
    guard lhs.route == rhs.route else { return false }
    return true
}
