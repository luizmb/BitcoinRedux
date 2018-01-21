//
//  HistoricalResponse.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public struct HistoricalResponse {
    public static let cacheFile = "historical_cache.bin"
    public let updatedTime: Date
    public let disclaimer: String?
    public let bpi: [Rate]

    public init(updatedTime: Date, disclaimer: String?, bpi: [Rate]) {
        self.updatedTime = updatedTime
        self.disclaimer = disclaimer
        self.bpi = bpi
    }
}

extension HistoricalResponse: Equatable {
    public static func ==(lhs: HistoricalResponse, rhs: HistoricalResponse) -> Bool {
        return lhs.updatedTime == rhs.updatedTime && lhs.disclaimer == rhs.disclaimer && lhs.bpi == rhs.bpi
    }
}
