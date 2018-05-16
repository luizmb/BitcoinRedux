import Foundation
import CommonLibrary

public protocol BitcoinRateAPI {
    func request(_ endpoint: BitcoinEndpoint, completion: @escaping (Result<Data>) -> ()) -> CancelableTask
}
