//
//  NavigationActionRequest.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import BitcoinLibrary
import CommonLibrary

public enum NavigationActionRequest: AppActionAsync {
    public typealias StateType = AppState

    case navigate(route: KnownRoute)

    public func execute(getState: @escaping () -> AppState,
                        dispatch: @escaping DispatchFunction,
                        dispatchAsync: @escaping (AnyActionAsync<StateType>) -> ()) {
        let currentState = getState()
        guard let navigationController = currentState.navigationController else { return }

        switch self {
        case .navigate(let journey):
            dispatch(RouterAction.willNavigate(journey.route))
            journey.navigate(navigationController) {
                dispatch(RouterAction.didNavigate(journey.route.destination))
            }
        }
    }
}
