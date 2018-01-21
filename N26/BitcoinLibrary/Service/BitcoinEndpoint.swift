//
//  BitcoinEndpoint.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public enum BitcoinEndpoint {
    case realtime(currency: String)
    case historical(currency: String, startDate: Date, endDate: Date)
}
