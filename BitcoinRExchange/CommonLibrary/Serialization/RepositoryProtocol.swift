import Foundation

public protocol RepositoryProtocol {
    func save(data: Data, filename: String)
    func load(filename: String) -> Result<Data>
}
