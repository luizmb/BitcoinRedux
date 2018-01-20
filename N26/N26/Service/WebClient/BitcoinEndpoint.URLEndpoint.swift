//
//  BitcoinEndpoint.URLEndpoint.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

extension BitcoinEndpoint {
    private var httpMethod: String {
        switch self {
        case .realtime: return "GET"
        case .historical: return "GET"
        }
    }
}

extension BitcoinEndpoint: URLEndpoint {
    var urlRequest: URLRequest {
        switch self {
        case let .realtime(currency):
            return URLRequest.createRequest(url: "https://api.coindesk.com/v1/bpi/currentprice/\(currency).json",
                                            httpMethod: httpMethod)
        case let .historical(currency, startDate, endDate):
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            return URLRequest.createRequest(url: "https://api.coindesk.com/v1/bpi/historical/close.json",
                                            httpMethod: httpMethod,
                                            urlParams: ["currency": currency,
                                                        "start": dateFormatter.string(from: startDate),
                                                        "end": dateFormatter.string(from: endDate)])
        }
    }
}
