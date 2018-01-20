//
//  StateProvider.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public protocol StateProvider {
    func map<B>(_ transform: @escaping (AppState) -> B) -> Signal<B>
    func map<B>(_ keyPath: KeyPath<AppState, B>) -> Signal<B>
    subscript<B>(_ keyPath: KeyPath<AppState, B>) -> Signal<B> { get }

    func subscribe(`if` condition: @escaping (AppState?, AppState) -> Bool,
                   _ handler: @escaping (AppState) -> ()) -> Disposable
    func subscribe(_ handler: @escaping (AppState) -> ()) -> Disposable
}

// Workaround while waiting for 'SE-0143: Conditional Conformance'
// https://github.com/apple/swift-evolution/blob/master/proposals/0143-conditional-conformances.md
//extension Signal: StateProvider where A: AppState {
//}

// So we wrap the protocol, instead. And we use the Store itself to wrap it, instead
// of introducing a new type.
extension Store: StateProvider {
    public func map<B>(_ transform: @escaping (AppState) -> B) -> Signal<B> {
        return stateSignal.map(transform)
    }

    public func map<B>(_ keyPath: KeyPath<AppState, B>) -> Signal<B> {
        return stateSignal.map(keyPath)
    }

    public subscript<B>(keyPath: KeyPath<AppState, B>) -> Signal<B> {
        return stateSignal[keyPath]
    }

    public func subscribe(if condition: @escaping (AppState?, AppState) -> Bool, _ handler: @escaping (AppState) -> ()) -> Disposable {
        return stateSignal.subscribe(if: condition, handler)
    }

    public func subscribe(_ handler: @escaping (AppState) -> ()) -> Disposable {
        return stateSignal.subscribe(handler)
    }
}
