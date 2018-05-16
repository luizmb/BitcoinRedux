import Foundation

public enum NavigationState: Equatable {
    case still(at: NavigationTree)
    case navigating(NavigationRoute)
}
