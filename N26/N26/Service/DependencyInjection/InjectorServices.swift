//
//  InjectorServices.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

extension InjectorProtocol {
    public var actionDispatcher: ActionDispatcher { return self.mapper.getSingleton()! }
    public var stateProvider: StateProvider { return self.mapper.getSingleton()! }
}

// MARK: - StateProvider (Singleton)
public protocol HasStateProvider { }

extension HasStateProvider {
    public static var stateProvider: StateProvider {
        return Injector.shared.stateProvider
    }

    public var stateProvider: StateProvider {
        return Injector.shared.stateProvider
    }
}

// MARK: - ActionDispatcher (StateStore Singleton)
public protocol HasActionDispatcher { }

extension HasActionDispatcher {
    public static var actionDispatcher: ActionDispatcher {
        return Injector.shared.actionDispatcher
    }

    public var actionDispatcher: ActionDispatcher {
        return Injector.shared.actionDispatcher
    }
}
