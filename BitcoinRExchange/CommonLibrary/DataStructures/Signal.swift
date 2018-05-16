import Foundation

public typealias OldValue<A> = A?
public typealias NewValue<A> = A
public typealias SignalValueChange<A> = (OldValue<A>, NewValue<A>) -> Void

public class Signal<A>: SignalProtocol {
    // MARK: - Private
    private typealias Token = UUID

    private var subscribers: Atomic<[Token: SignalSubscriber<A>]> = Atomic([:])

    internal var onSubscribe: OnSubscribe<A> = .doNothing

    private var sink: SignalValueChange<A> {
        return { [weak self] oldValue, newValue in
            self?.send(oldValue: oldValue, newValue: newValue)
        }
    }

    private lazy var addSubscriber: (@escaping (OldValue<A>, NewValue<A>) -> Bool,
        _ handler: @escaping (NewValue<A>) -> Void) -> Disposable = { [weak self] condition, handler in
            guard let strongSelf = self else { return Disposable { } }

            let token = UUID()

            strongSelf.subscribers.mutate { $0[token] = SignalSubscriber(handler, if: condition) }
            if case .notify(let getCurrentValue) = strongSelf.onSubscribe,
                let currentValue = getCurrentValue() {
                strongSelf.subscribers.atomicProperty[token]?.notify(oldValue: nil, newValue: currentValue)
            }

            return Disposable { [weak self] in
                self?.subscribers.mutate { $0[token] = nil }
            }
    }

    private func send(oldValue: OldValue<A>, newValue: NewValue<A>) {
        let syncSubscribers = subscribers.atomicProperty
        syncSubscribers.forEach { _, subscriber in
            subscriber.notify(oldValue: oldValue, newValue: newValue)
        }
    }

    // MARK: - Public
    required public init() { }

    public class func pipe<T: Signal<A>>(onSubscribe: OnSubscribe<A> = .doNothing) -> (SignalValueChange<A>, T) {
        let signal = T()
        signal.onSubscribe = onSubscribe
        return (signal.sink, signal)
    }
}

extension Signal {
    public func map<B>(_ transform: @escaping (A) -> B) -> Signal<B> {
        let signal = Signal<B>()

        signal.addSubscriber = { [weak self] condition, handler in
            guard let strongSelf = self else { return Disposable { } }
            return strongSelf.subscribe(
                if: { condition($0.flatMap(transform), transform($1)) }, { handler(transform($0)) }
            )
        }
        return signal
    }
}

// MARK: - Subscribe
extension Signal {
    public func subscribe(`if` condition: @escaping (OldValue<A>, NewValue<A>) -> Bool,
                          _ handler: @escaping (NewValue<A>) -> Void) -> Disposable {
        return addSubscriber(condition, handler)
    }
}

// MARK: - SignalSubscriber
private struct SignalSubscriber<A> {
    private let notificationHandler: (A) -> Void
    private let condition: (A?, A) -> Bool

    init(_ handler: @escaping (A) -> Void,
         `if` condition: @escaping (A?, A) -> Bool) {
        self.notificationHandler = handler
        self.condition = condition
    }

    fileprivate func notify(oldValue: A?, newValue: A) {
        if condition(oldValue, newValue) {
            notificationHandler(newValue)
        }
    }
}

public enum OnSubscribe<A> {
    case notify(currentValue: () -> A?)
    case doNothing
}
