//
//  Currency.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String?

    enum CodingKeys: String, CodingKey {
        case code
        case name = "description"
        case symbol
    }
}

extension Currency: Hashable {
    public var hashValue: Int {
        return code.hashValue
    }

    public static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }
}
