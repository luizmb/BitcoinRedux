import CommonLibrary
import Foundation
import RxSwift
import SwiftRex

public protocol BitcoinStateProvider {
    func map<B>(_ transform: @escaping (GlobalState) throws -> B) rethrows -> Observable<B>
    func map<B>(_ keyPath: KeyPath<GlobalState, B>) -> Observable<B>
    subscript<B>(_ keyPath: KeyPath<GlobalState, B>) -> Observable<B> { get }
    func subscribe(if condition: @escaping (GlobalState?, GlobalState) -> Bool,
                   _ handler: @escaping (GlobalState) -> Void) -> Disposable
    func subscribe(_ handler: @escaping (GlobalState) -> Void) -> Disposable
}

extension BitcoinStore: BitcoinStateProvider {
    public func subscribe(_ handler: @escaping (GlobalState) -> Void) -> Disposable {
        return subscribe(onNext: handler, onError: nil, onCompleted: nil, onDisposed: nil)
    }

    public func map<B>(_ keyPath: KeyPath<GlobalState, B>) -> Observable<B> {
        return map { observable in observable[keyPath: keyPath] }
    }

    public subscript<B>(keyPath: KeyPath<GlobalState, B>) -> Observable<B> {
        return map(keyPath)
    }

    public func subscribe(if condition: @escaping (GlobalState?, GlobalState) -> Bool,
                          _ handler: @escaping (GlobalState) -> Void) -> Disposable {
        return
            scan((GlobalState?.none, GlobalState?.none)) { previous, newValue in
                return (previous.1, newValue)
            }.filter { pair in
                condition(pair.0, pair.1!)
            }.map {
                $0.1!
            }.subscribe(onNext: handler, onError: nil, onCompleted: nil, onDisposed: nil)
    }
}
