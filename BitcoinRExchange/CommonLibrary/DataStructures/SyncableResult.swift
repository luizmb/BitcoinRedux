import Foundation

public enum SyncableResult<T> {
    case neverLoaded
    case syncing(task: CancelableTask, oldValue: Result<T>?)
    case loaded(Result<T>)
}

extension SyncableResult: Equatable where T: Equatable {}
public func == <T: Equatable>(lhs: SyncableResult<T>, rhs: SyncableResult<T>) -> Bool {
    switch (lhs, rhs) {
    case (.neverLoaded, .neverLoaded):
        return true
    case let (.syncing(_, lhsOldValue), .syncing(_, rhsOldValue)):
        return lhsOldValue == rhsOldValue
    case let (.loaded(lhsResult), .loaded(rhsResult)):
        return lhsResult == rhsResult
    default: return false
    }
}

extension SyncableResult {
    public func possibleResult() -> Result<T>? {
        switch self {
        case .neverLoaded: return nil
        case .syncing(_, let oldValue): return oldValue
        case .loaded(let value): return value
        }
    }

    public func possibleValue() -> T? {
        return self.possibleResult().flatMap {
            switch $0 {
            case .success(let value): return value
            default: return nil
            }
        }
    }
}
