import Foundation
import BitcoinLibrary
import CommonLibrary

public class DefaultMapResolver {
    private static let diskCache = DiskCache()

    public static func mapServices() {
        guard let injector = (Injector.shared as? Injector) else { return }

        injector.mapper.mapSingleton(ActionDispatcher.self) { return Store.shared }
        injector.mapper.mapSingleton(BitcoinRateAPI.self) { return BitcoinAPIClient.shared }
        injector.mapper.mapSingleton(RepositoryProtocol.self) { return diskCache }
        injector.mapper.mapSingleton(StateProvider.self) { Store.shared }
    }
}

extension DefaultMapResolver {
    public static func map() {
        mapServices()
    }
}
