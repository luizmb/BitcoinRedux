//
//  Store.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import BitcoinLibrary
import CommonLibrary

public protocol AppActionAsync: ActionAsync where StateType == AppState {
}

public protocol ActionDispatcher {
    func dispatch(_ action: Action)
    func async<AppActionAsyncType: AppActionAsync>(_ action: AppActionAsyncType)
}

final public class Store: StoreBase<AppState, EntryPointReducer> {
    static let shared: Store = {
        let global = Store()
        return global
    }()

    private init() {
        super.init(initialState: AppState(), reducer: EntryPointReducer())
    }
}

extension Store: ActionDispatcher { }
