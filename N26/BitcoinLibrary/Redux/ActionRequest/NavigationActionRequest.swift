//
//  NavigationActionRequest.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

public enum NavigationActionRequest: AppActionAsync {
    public typealias StateType = AppState

    case navigate(route: KnownRoute)

    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<StateType>) -> ()) {
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
