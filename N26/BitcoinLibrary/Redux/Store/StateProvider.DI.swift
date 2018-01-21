//
//  StateProvider.DI.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

extension InjectorProtocol {
    public var stateProvider: StateProvider { return self.mapper.getSingleton()! }
}

public protocol HasStateProvider { }
extension HasStateProvider {
    public static var stateProvider: StateProvider {
        return injector().stateProvider
    }

    public var stateProvider: StateProvider {
        return injector().stateProvider
    }
}
