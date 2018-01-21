//
//  ActionDispatcher.DI.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

extension InjectorProtocol {
    public var actionDispatcher: ActionDispatcher { return self.mapper.getSingleton()! }
}

public protocol HasActionDispatcher { }
extension HasActionDispatcher {
    public static var actionDispatcher: ActionDispatcher {
        return injector().actionDispatcher
    }

    public var actionDispatcher: ActionDispatcher {
        return injector().actionDispatcher
    }
}
