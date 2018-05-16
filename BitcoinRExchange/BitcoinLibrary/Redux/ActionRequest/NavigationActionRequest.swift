import CommonLibrary
import Foundation

public enum NavigationActionRequest: AppActionAsync {
    public typealias StateType = AppState

    case navigate(route: KnownRoute)

    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<StateType>) -> Void) {
        let currentState = getState()
        #if os(iOS)
        guard let navigationController = currentState.navigationController else { return }
        #endif

        switch self {
        case .navigate(let journey):
            dispatch(RouterAction.willNavigate(journey.route))
            #if os(iOS)
            journey.navigate(navigationController) {
                dispatch(RouterAction.didNavigate(journey.route.destination))
            }
            #else
            journey.navigate {
                dispatch(RouterAction.didNavigate(journey.route.destination))
            }
            #endif
        }
    }
}
