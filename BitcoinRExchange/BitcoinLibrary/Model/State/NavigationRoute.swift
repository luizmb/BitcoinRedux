import Foundation

public struct NavigationRoute {
    public let origin: NavigationTree
    public let destination: NavigationTree
}

extension NavigationRoute: Equatable {
    public static func == (lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        return lhs.origin == rhs.origin && lhs.destination == rhs.destination
    }
}
