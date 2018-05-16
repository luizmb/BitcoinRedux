import Foundation

public enum Result<T> {
    case success(T)
    case error(Error)
}

// MARK: - Functor, Monad
extension Result {
    public func map<B>(_ transform: (T) -> (B)) -> Result<B> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let valueT): return .success(transform(valueT))
        }
    }

    public func flatMap<B>(_ transform: (T) -> (Result<B>)) -> Result<B> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let valueT): return transform(valueT)
        }
    }
}

// MARK: - Equatable
extension Result: Equatable where T: Equatable {}
public func == <T: Equatable>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    switch (lhs, rhs) {
    case let (.error(errorLeft), .error(errorRight)):
        return errorLeft.localizedDescription == errorRight.localizedDescription
    case let (.success(valueLeft), .success(valueRight)):
        return valueLeft == valueRight
    default: return false
    }
}
