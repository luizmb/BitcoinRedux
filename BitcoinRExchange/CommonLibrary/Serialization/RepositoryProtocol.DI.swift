import Foundation

extension InjectorProtocol {
    public var repository: RepositoryProtocol { return self.mapper.getSingleton()! }
}

public protocol HasRepository { }
extension HasRepository {
    public static var repository: RepositoryProtocol {
        return injector().repository
    }

    public var repository: RepositoryProtocol {
        return injector().repository
    }
}
