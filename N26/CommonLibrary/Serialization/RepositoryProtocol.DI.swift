//
//  RepositoryProtocol.DI.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

extension InjectorProtocol {
    public var repository: RepositoryProtocol { return self.mapper.getSingleton()! }
}

public protocol HasRepository { }
extension HasRepository {
    public static var repository: RepositoryProtocol {
        return injector().repository
    }

    public var repository: RepositoryProtocol {
        return injector().repository
    }
}
