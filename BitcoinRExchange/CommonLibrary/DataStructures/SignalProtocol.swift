import Foundation

public protocol SignalProtocol {
    associatedtype SignalType

    func map<B>(_ transform: @escaping (SignalType) -> B) -> Signal<B>
    func subscribe(`if` condition: @escaping (SignalType?, SignalType) -> Bool,
                   _ handler: @escaping (SignalType) -> Void) -> Disposable
}

extension SignalProtocol where SignalType: Sequence, SignalType.Element: Equatable {
    public func subscribe(_ handler: @escaping (SignalType) -> Void) -> Disposable {
        return subscribe(if: {
            guard let old = $0 else { return true }
            return !old.elementsEqual($1)
        }, handler)
    }
}

extension SignalProtocol where SignalType: Equatable {
    public func subscribe(_ handler: @escaping (SignalType) -> Void) -> Disposable {
        return subscribe(if: !=, handler)
    }
}

extension SignalProtocol {
    public func map<B>(_ keyPath: KeyPath<SignalType, B>) -> Signal<B> {
        return self.map { $0[keyPath: keyPath] }
    }

    public subscript<B>(_ keyPath: KeyPath<SignalType, B>) -> Signal<B> {
        return self.map { $0[keyPath: keyPath] }
    }
}
