//
//  HistoricalResponse.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public struct HistoricalResponse {
    static let cacheFile = "historical_cache"
    let updatedTime: Date
    let disclaimer: String?
    let bpi: [Rate]
}

extension HistoricalResponse: Equatable {
    public static func ==(lhs: HistoricalResponse, rhs: HistoricalResponse) -> Bool {
        return lhs.updatedTime == rhs.updatedTime && lhs.disclaimer == rhs.disclaimer && lhs.bpi == rhs.bpi
    }
}
