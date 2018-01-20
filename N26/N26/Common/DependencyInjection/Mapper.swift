//
//  Mapper.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public struct Mapper {
    public init() { }
    
    private var dictionary: [String: AnyConstructorType] = [String: AnyConstructorType]()

    public mutating func mapSingleton<T>(_ singleton: @escaping () -> T) {
        self.mapSingleton(T.self, singleton: singleton)
    }

    public mutating func mapFactory<T>(_ factory: @escaping () -> (() -> T)) {
        self.mapFactory(T.self, factory: factory)
    }

    public mutating func mapSingleton<T>(_ type: T.Type, singleton: @escaping () -> T) {
        dictionary[String(describing: T.self)] = ConstructorType<T>.singleton(singleton)
    }

    public mutating func mapFactory<T>(_ type: T.Type, factory: @escaping () -> (() -> T)) {
        dictionary[String(describing: T.self)] = ConstructorType<T>.factory(factory)
    }

    public func getFactory<T>() -> (() -> T)? {
        guard let any = dictionary[String(describing: T.self)] as? ConstructorType<T> else { return nil }
        guard case .factory(let factory) = any else { return nil}
        return factory()
    }

    public func getSingleton<T>() -> T? {
        guard let any = dictionary[String(describing: T.self)] as? ConstructorType<T> else { return nil }
        guard case .singleton(let factory) = any else { return nil}
        return factory()
    }

#if DEBUG
    public func dump(to mapper: inout Mapper) {
        dictionary.forEach { k, v in mapper.dictionary[k] = v }
    }
#endif
}
