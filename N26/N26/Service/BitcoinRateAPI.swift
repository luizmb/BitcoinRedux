//
//  BitcoinRateAPI.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

public protocol BitcoinRateAPI {
    func request(_ endpoint: BitcoinEndpoint, completion: @escaping (Result<Data>) -> ()) -> CancelableTask
}
