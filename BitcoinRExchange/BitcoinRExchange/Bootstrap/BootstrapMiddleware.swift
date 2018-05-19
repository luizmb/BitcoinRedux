import BitcoinLibrary
import CommonLibrary
import SwiftRex
import UIKit

public class BootstrapMiddleware: Middleware {
    public typealias StateType = ApplicationState
    public var actionHandler: ActionHandler?

    public func handle(event: EventProtocol,
                       getState: @escaping () -> ApplicationState,
                       next: @escaping (EventProtocol, @escaping () -> ApplicationState) -> Void) {

        defer {
            next(event, getState)
            next(BitcoinRateEvent.setup, getState)
        }

        guard let applicationEvent = event as? ApplicationEvent else { return }

        switch applicationEvent {
        case let .boot(application, window, _):
            Theme.apply()
            application.keepScreenOn = true

            let navigationController = UINavigationController(rootViewController: HistoricalViewController.start()!)
            window.setup(with: navigationController)

            actionHandler?.trigger(RouterAction.didStart(application, navigationController))
        }
    }

    public func handle(action: ActionProtocol,
                       getState: @escaping () -> ApplicationState,
                       next: @escaping (ActionProtocol, @escaping () -> ApplicationState) -> Void) {

        next(action, getState)
    }

    public init() { }
}
