import BitcoinLibrary
import CommonLibrary
import WatchKit

enum BootstrapRequest: AppActionAsync {
    case boot

    func execute(getState: @escaping () -> AppState,
                 dispatch: @escaping DispatchFunction,
                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> Void) {
        switch self {
        case .boot:
            dispatch(RouterAction.didStart)
        }
    }
}
