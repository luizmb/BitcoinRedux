//
//  DefaultMapResolver.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

public class DefaultMapResolver {
    public static func mapServices() {
        guard let injector = (Injector.shared as? Injector) else { return }

        injector.mapper.mapSingleton(ActionDispatcher.self) { return Store.shared }
        injector.mapper.mapSingleton(BitcoinRateAPI.self) { return BitcoinAPIClient.shared }
        injector.mapper.mapSingleton(RepositoryProtocol.self) { return DiskCache.shared }
        injector.mapper.mapSingleton(StateProvider.self) { Store.shared }
    }
}

extension DefaultMapResolver {
    static func map() {
        mapServices()
    }
}
