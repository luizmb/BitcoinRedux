import Foundation

public enum Result<T: Equatable> {
    case success(T)
    case error(Error)
}

// MARK: - Functor, Monad
extension Result {
    func map<B>(_ transformation: (T) -> (B)) -> Result<B> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let valueT): return .success(transformation(valueT))
        }
    }

    func flatMap<B>(_ transformation: (T) -> (Result<B>)) -> Result<B> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let valueT): return transformation(valueT)
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
