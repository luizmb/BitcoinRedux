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
        return injector().actionDispatcher
    }

    public var actionDispatcher: ActionDispatcher {
        return injector().actionDispatcher
    }
}

// MARK: - BitcoinRateAPI (Singleton)
public protocol HasBitcoinRateAPI { }

extension HasBitcoinRateAPI {
    public static var bitcoinRateAPI: BitcoinRateAPI {
        return injector().bitcoinRateAPI
    }

    public var bitcoinRateAPI: BitcoinRateAPI {
        return injector().bitcoinRateAPI
    }
}

// MARK: - StateProvider (Singleton)
public protocol HasStateProvider { }

extension HasStateProvider {
    public static var stateProvider: StateProvider {
        return injector().stateProvider
    }

    public var stateProvider: StateProvider {
        return injector().stateProvider
    }
}
