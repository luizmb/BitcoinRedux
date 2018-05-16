import UIKit
import BitcoinLibrary
import CommonLibrary

enum BootstrapRequest: AppActionAsync {
    case boot(application: Application, window: Window, launchOptions: [UIApplicationLaunchOptionsKey: Any]?)

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> ()) {
        switch self {
        case .boot(let application, let window, _):
            Theme.apply()
            application.keepScreenOn = true

            let navigationController = UINavigationController(rootViewController: HistoricalViewController.start()!)
            window.setup(with: navigationController)

            dispatch(RouterAction.didStart(application, navigationController))
        }
    }
}
