import Foundation

public final class Atomic<A> {
    private var queue = DispatchQueue(label: "atomic property serial queue")
    private var value: A
    public init(_ value: A) {
        self.value = value
    }
    
    public var atomicProperty: A {
        return queue.sync { self.value }
    }
    
    public func mutate(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self.value)
        }
    }
}
