//
//  HistoricalResponse.Codable.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

extension HistoricalResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case time
        case disclaimer
        case bpi
    }

    enum TimeCodingKeys: String, CodingKey {
        case updatedTime = "updatedISO"
    }

    struct RateCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timeContainer = try container.nestedContainer(keyedBy: TimeCodingKeys.self, forKey: .time)
        let updatedTime = try timeContainer.decode(Date.self, forKey: .updatedTime)
        let disclaimer = try container.decodeIfPresent(String.self, forKey: .disclaimer)
        let bpiContainer = try container.nestedContainer(keyedBy: RateCodingKeys.self, forKey: .bpi)

        var rates: [Rate] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        for key in bpiContainer.allKeys {
            let date = dateFormatter.date(from: key.stringValue)!
            let rate = try bpiContainer.decode(Float.self, forKey: key)
            rates.append(Rate(date: date, rate: rate))
        }

        self.init(updatedTime: updatedTime, disclaimer: disclaimer, bpi: rates.sorted(by: { $0.date > $1.date }))
    }
}
