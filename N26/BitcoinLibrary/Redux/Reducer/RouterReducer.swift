//
//  RouterReducer.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

public struct RouterReducer: Reducer {
    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        guard let routerAction = action as? RouterAction else { return currentState }

        var stateCopy = currentState

        #if os(iOS)
            switch routerAction {
            case .didStart(let application, let navigationController):
                stateCopy.application = application
                stateCopy.navigation = .still(at: .root())
                stateCopy.navigationController = navigationController
            case .willNavigate(let route):
                stateCopy.navigation = .navigating(route)
            case .didNavigate(let destination):
                stateCopy.navigation = .still(at: destination)
            }
        #else
            switch routerAction {
            case .didStart:
                stateCopy.navigation = .still(at: .root())
            case .willNavigate(let route):
                stateCopy.navigation = .navigating(route)
            case .didNavigate(let destination):
                stateCopy.navigation = .still(at: destination)
            }
        #endif

        return stateCopy
    }
}
