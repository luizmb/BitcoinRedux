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
    public var bitcoinRateAPI: BitcoinRateAPI { return self.mapper.getSingleton()! }
    public var stateProvider: StateProvider { return self.mapper.getSingleton()! }
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

// MARK: - BitcoinRateAPI (Singleton)
public protocol HasBitcoinRateAPI { }

extension HasBitcoinRateAPI {
    public static var bitcoinRateAPI: BitcoinRateAPI {
        return Injector.shared.bitcoinRateAPI
    }

    public var bitcoinRateAPI: BitcoinRateAPI {
        return Injector.shared.bitcoinRateAPI
    }
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
