import Foundation
import CommonLibrary

public class BitcoinAPIClient: BitcoinRateAPI {
    public static let shared: BitcoinRateAPI = {
        let global = BitcoinAPIClient(session: URLSession.shared)
        return global
    }()

    enum BitcoinAPIClientError: Error {
        case invalidResponse
        case statusCodeError(statusCode: Int, data: Data?)
    }

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    @discardableResult public func request(_ endpoint: BitcoinEndpoint, completion: @escaping (Result<Data>) -> ()) -> CancelableTask {
        let task = session.dataTask(with: endpoint.urlRequest) { data, response, error in
            switch (error, response as? HTTPURLResponse) {
            case (.some(let err), _): completion(.error(err)); return
            case (.none, .none): completion(.error(BitcoinAPIClientError.invalidResponse)); return
            case (.none, .some(let httpResponse)):
                guard httpResponse.statusCode < 300 else {
                    completion(.error(BitcoinAPIClientError.statusCodeError(statusCode: httpResponse.statusCode,
                                                                            data: data)))
                    return
                }
                completion(.success(data!))
            }
        }
        task.resume()
        return task
    }
}
