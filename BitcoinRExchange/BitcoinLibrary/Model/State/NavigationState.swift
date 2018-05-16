import Foundation

public enum NavigationState {
    case still(at: NavigationTree)
    case navigating(NavigationRoute)
}

extension NavigationState: Equatable {
    public static func == (lhs: NavigationState, rhs: NavigationState) -> Bool {
        switch (lhs, rhs) {
        case let (.still(lhs), .still(rhs)):
            return lhs == rhs
        case let (.navigating(lhs), .navigating(rhs)):
            return lhs == rhs
        default: return false
        }
    }
}
