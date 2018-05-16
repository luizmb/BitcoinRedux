import Foundation

public enum NavigationTree {
    case listHistoricalAndRealtime

    public static func root() -> NavigationTree {
        return .listHistoricalAndRealtime
    }
}

extension NavigationTree: Equatable { }
