import CommonLibrary
import Foundation

public struct RouterReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let routerAction = action as? RouterAction else { return currentState }

        var stateCopy = currentState

        #if os(iOS)
            switch routerAction {
            case let .didStart(application, navigationController):
                stateCopy.application = application
                stateCopy.navigation = .still(at: .root())
                stateCopy.navigationController = navigationController
            case let .willNavigate(route):
                stateCopy.navigation = .navigating(route)
            case let .didNavigate(destination):
                stateCopy.navigation = .still(at: destination)
            }
        #else
            switch routerAction {
            case .didStart:
                stateCopy.navigation = .still(at: .root())
            case let .willNavigate(route):
                stateCopy.navigation = .navigating(route)
            case let .didNavigate(destination):
                stateCopy.navigation = .still(at: destination)
            }
        #endif

        return stateCopy
    }
}
