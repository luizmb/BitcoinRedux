import CommonLibrary
import Foundation
import SwiftRex

public let routerReducer = Reducer<ApplicationState> { state, action in
    guard let routerAction = action as? RouterAction else { return state }

    var applicationState = state

    #if os(iOS)
    switch routerAction {
    case let .didStart(application, navigationController):
        applicationState.application = application
        applicationState.navigation = .still(at: .root())
        applicationState.navigationController = navigationController
    case let .navigationStarted(_, route):
        applicationState.navigation = .navigating(route)
    case let .didNavigate(destination):
        applicationState.navigation = .still(at: destination)
    }
    #else
    switch routerAction {
    case .didStart:
        applicationState.navigation = .still(at: .root())
    case let .navigationStarted(route):
        applicationState.navigation = .navigating(route)
    case let .didNavigate(destination):
        applicationState.navigation = .still(at: destination)
    }
    #endif

    return applicationState
}
