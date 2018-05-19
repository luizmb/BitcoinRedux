import CommonLibrary
import Foundation
import SwiftRex

public class NavigationMiddleware: Middleware {
    public typealias StateType = ApplicationState
    public var actionHandler: ActionHandler?

    public func handle(event: EventProtocol,
                       getState: @escaping () -> ApplicationState,
                       next: @escaping (EventProtocol, @escaping () -> ApplicationState) -> Void) {

        defer {
            next(event, getState)
        }

        let currentState = getState()
        guard let routerEvent = event as? RouterEvent else { return }

        #if os(iOS)
        guard let navigationController = currentState.navigationController else { return }

        switch routerEvent {
        case let .navigateRequest(viewController, journey):
            actionHandler?.trigger(RouterAction.navigationStarted(source: viewController, route: journey.route))
            journey.navigate(navigationController) { [weak self] in
                self?.actionHandler?.trigger(RouterAction.didNavigate(journey.route.destination))
            }
        }
        #else
        switch routerEvent {
        case let .navigateRequest(journey):
            actionHandler?.trigger(RouterAction.navigationStarted(route: journey.route))
            journey.navigate { [weak self] in
                self?.actionHandler?.trigger(RouterAction.didNavigate(journey.route.destination))
            }
        }
        #endif
    }

    public func handle(action: ActionProtocol,
                       getState: @escaping () -> ApplicationState,
                       next: @escaping (ActionProtocol, @escaping () -> ApplicationState) -> Void) {

        next(action, getState)
    }

    public init() { }
}
