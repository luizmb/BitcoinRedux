//
//  JsonParser.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public class JsonParser {
    public static func decode<T: Decodable>(_ data: Data) -> Result<T> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let result = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .error(error)
        }
    }
}
