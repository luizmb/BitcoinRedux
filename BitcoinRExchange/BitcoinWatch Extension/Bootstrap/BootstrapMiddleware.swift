import BitcoinLibrary
import CommonLibrary
import SwiftRex

public class BootstrapMiddleware: Middleware {
    public typealias StateType = ApplicationState
    public var actionHandler: ActionHandler?

    public func handle(event: EventProtocol,
                       getState: @escaping () -> ApplicationState,
                       next: @escaping (EventProtocol, @escaping () -> ApplicationState) -> Void) {

        defer {
            next(event, getState)
        }

        guard let applicationEvent = event as? ApplicationEvent else { return }

        switch applicationEvent {
        case .boot:
            actionHandler?.trigger(RouterAction.didStart)
        }
    }

    public func handle(action: ActionProtocol,
                       getState: @escaping () -> ApplicationState,
                       next: @escaping (ActionProtocol, @escaping () -> ApplicationState) -> Void) {

        next(action, getState)
    }

    public init() { }
}
