//
//  EntryPointReducer.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

public struct EntryPointReducer: Reducer {

    public init() { }

    public typealias StateType = AppState
    private let reducers = [
        AnyReducer(RouterReducer()),
        AnyReducer(BitcoinRateReducer())
    ]

    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        return reducers.reduce(currentState) { $1.reduce($0, action: action) }
    }
}
