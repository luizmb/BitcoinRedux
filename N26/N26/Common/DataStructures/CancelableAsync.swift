import Foundation

public enum CancelableAsync<T: Equatable> {
    case notLoaded
    case loading(CancelableTask)
    case loaded(T)
}

extension CancelableAsync: Equatable {}
public func ==<T>(lhs: CancelableAsync<T>, rhs: CancelableAsync<T>) -> Bool {
    switch (lhs, rhs) {
    case (.notLoaded, .notLoaded):
        return true
    case (.loading, .loading):
        return true
    case (.loaded(let lhs), .loaded(let rhs)):
        return lhs == rhs
    default: return false
    }
}
