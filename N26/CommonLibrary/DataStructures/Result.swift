import Foundation

public enum Result<T: Equatable> {
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
extension Result: Equatable {
    public static func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
        switch (lhs, rhs) {
        case (.error(let errorLeft), .error(let errorRight)):
            return errorLeft.localizedDescription == errorRight.localizedDescription
        case (.success(let valueLeft), .success(let valueRight)):
            return valueLeft == valueRight
        default: return false
        }
    }
}

// Workaround while waiting for 'SE-0143: Conditional Conformance'
// https://github.com/apple/swift-evolution/blob/master/proposals/0143-conditional-conformances.md

// As Array of Equatable is not Equatable (despite of having `==` function), we have to duplicate
// this enum for the array case. This won't longer be required as soon as SE-0143 is available
public enum ResultArray<T: Equatable> {
    case success([T])
    case error(Error)
}

// MARK: - Functor, Monad
extension ResultArray {
    func map<B: Equatable>(_ transform: (T) -> (B)) -> ResultArray<B> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let arrayOfT): return .success(arrayOfT.map(transform))
        }
    }

    func flatMap<B: Equatable>(_ transform: (T) -> (B?)) -> ResultArray<B> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let arrayOfT): return .success(arrayOfT.flatMap(transform))
        }
    }
}

// MARK: - Equatable
extension ResultArray: Equatable {
    public static func ==<T>(lhs: ResultArray<T>, rhs: ResultArray<T>) -> Bool {
        switch (lhs, rhs) {
        case (.error(let errorLeft), .error(let errorRight)):
            return errorLeft.localizedDescription == errorRight.localizedDescription
        case (.success(let valueLeft), .success(let valueRight)):
            return valueLeft == valueRight
        default: return false
        }
    }
}
