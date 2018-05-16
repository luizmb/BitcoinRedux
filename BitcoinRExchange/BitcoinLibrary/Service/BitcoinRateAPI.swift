import CommonLibrary
import Foundation

public protocol BitcoinRateAPI {
    func request(_ endpoint: BitcoinEndpoint, completion: @escaping (Result<Data>) -> Void) -> CancelableTask
}
