//
//  URLRequest.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

extension URLRequest {
    public static func createRequest(url urlString: String,
                                     httpMethod: String,
                                     urlParams: [String: String] = [:]) -> URLRequest {
        let urlSuffix = urlParams.count == 0 ? "" : "?" + urlParams.map { k, v in "\(k)=\(v)" }.joined(separator: "&")
        let url = URL(string: "\(urlString)\(urlSuffix)")!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
