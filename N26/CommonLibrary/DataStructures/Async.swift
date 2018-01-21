import Foundation

public enum Async<T> {
    case notLoaded
    case loading
    case loaded(T)
}
