import Foundation

public protocol AnyConstructorType { }

public enum ConstructorType<T>: AnyConstructorType {
    case singleton(() -> T)
    case factory(() -> (() -> T))
}
