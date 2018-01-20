//
//  InjectorProtocol.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public protocol InjectorProtocol {
    static var shared: InjectorProtocol { get }
    var mapper: Mapper { get }
}
