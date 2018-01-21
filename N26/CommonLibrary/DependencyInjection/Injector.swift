//
//  Injector.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public class Injector: InjectorProtocol {
    public static let shared: InjectorProtocol = {
        let global = Injector()
        return global
    }()

    public var mapper: Mapper = Mapper()
}

#if DEBUG || TESTING
    public class MockInjector: InjectorProtocol {
        public static var getInjector: () -> InjectorProtocol? = { nil }
        public var mapper: Mapper = Mapper()

        public func injectDefaults() {
            Injector.shared.mapper.dump(to: &mapper)
        }
    }
#endif

#if TESTING
    public func injector() -> InjectorProtocol {
        return MockInjector.getInjector()!
    }
#else
    public func injector() -> InjectorProtocol {
        return Injector.shared
    }
#endif
