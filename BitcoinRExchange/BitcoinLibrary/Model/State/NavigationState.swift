import Foundation

public enum NavigationState {
    case still(at: NavigationTree)
    case navigating(NavigationRoute)
}

extension NavigationState: Equatable {
    public static func ==(lhs: NavigationState, rhs: NavigationState) -> Bool {
        switch (lhs, rhs) {
        case (.still(let lhs), .still(let rhs)):
            return lhs == rhs
        case (.navigating(let lhs), .navigating(let rhs)):
            return lhs == rhs
        default: return false
        }
    }
}
