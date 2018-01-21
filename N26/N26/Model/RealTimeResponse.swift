//
//  RealTimeResponse.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public struct RealTimeResponse {
    static let cacheFile = "realtime_cache"
    let updatedTime: Date
    let disclaimer: String?
    let bpi: [Currency: Float]
}

extension RealTimeResponse: Equatable {
    public static func ==(lhs: RealTimeResponse, rhs: RealTimeResponse) -> Bool {
        return lhs.updatedTime == rhs.updatedTime && lhs.disclaimer == rhs.disclaimer && lhs.bpi == rhs.bpi
    }
}
