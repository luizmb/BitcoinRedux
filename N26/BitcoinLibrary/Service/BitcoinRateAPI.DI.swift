//
//  BitcoinRateAPI.DI.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

extension InjectorProtocol {
    public var bitcoinRateAPI: BitcoinRateAPI { return self.mapper.getSingleton()! }
}

public protocol HasBitcoinRateAPI { }
extension HasBitcoinRateAPI {
    public static var bitcoinRateAPI: BitcoinRateAPI {
        return injector().bitcoinRateAPI
    }

    public var bitcoinRateAPI: BitcoinRateAPI {
        return injector().bitcoinRateAPI
    }
}
