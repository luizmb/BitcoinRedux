//
//  BitcoinAPIClient.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

public class BitcoinAPIClient: BitcoinRateAPI {
    static let shared: BitcoinRateAPI = {
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
            if let error = error {
                completion(.error(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.error(BitcoinAPIClientError.invalidResponse))
                return
            }

            guard response.statusCode < 300 else {
                completion(.error(BitcoinAPIClientError.statusCodeError(statusCode: response.statusCode,
                                                                        data: data)))
                return
            }

            if let data = data {
                completion(.success(data))
                return
            }

            fatalError("No data and no error")
        }
        task.resume()
        return task
    }
}
