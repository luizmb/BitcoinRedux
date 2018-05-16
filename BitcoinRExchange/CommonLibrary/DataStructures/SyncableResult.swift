import Foundation

public enum SyncableResult<T: Equatable> {
    case neverLoaded
    case syncing(task: CancelableTask, oldValue: Result<T>?)
    case loaded(Result<T>)
}

extension SyncableResult: Equatable {}
public func ==<T>(lhs: SyncableResult<T>, rhs: SyncableResult<T>) -> Bool {
    switch (lhs, rhs) {
    case (.neverLoaded, .neverLoaded):
        return true
    case (.syncing(_, let lhsOldValue), .syncing(_, let rhsOldValue)):
        return lhsOldValue == rhsOldValue
    case (.loaded(let lhsResult), .loaded(let rhsResult)):
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

// Workaround while waiting for 'SE-0143: Conditional Conformance'
// https://github.com/apple/swift-evolution/blob/master/proposals/0143-conditional-conformances.md

// As Array of Equatable is not Equatable (despite of having `==` function), we have to duplicate
// this enum for the array case. This won't longer be required as soon as SE-0143 is available

public enum SyncableArrayResult<T: Equatable> {
    case neverLoaded
    case syncing(task: CancelableTask, oldValue: ResultArray<T>?)
    case loaded(ResultArray<T>)
}

extension SyncableArrayResult {
    public func possibleResult() -> ResultArray<T>? {
        switch self {
        case .neverLoaded: return nil
        case .syncing(_, let oldValue): return oldValue
        case .loaded(let value): return value
        }
    }

    public func possibleValue() -> [T]? {
        return self.possibleResult().flatMap {
            switch $0 {
            case .success(let value): return value
            default: return nil
            }
        }
    }
}

extension SyncableArrayResult {
    public func map<B: Equatable>(_ transform: (T) -> B) -> SyncableArrayResult<B> {
        switch self {
        case .neverLoaded: return .neverLoaded
        case .syncing(let task, let oldValue):
            return .syncing(task: task, oldValue: oldValue.map { $0.map(transform) })
        case .loaded(let value): return .loaded(value.map(transform))
        }
    }
}

extension SyncableArrayResult: Equatable {}
public func ==<T>(lhs: SyncableArrayResult<T>, rhs: SyncableArrayResult<T>) -> Bool {
    switch (lhs, rhs) {
    case (.neverLoaded, .neverLoaded):
        return true
    case (.syncing(_, let lhsOldValue), .syncing(_, let rhsOldValue)):
        return lhsOldValue == rhsOldValue
    case (.loaded(let lhsResult), .loaded(let rhsResult)):
        return lhsResult == rhsResult
    default: return false
    }
}
