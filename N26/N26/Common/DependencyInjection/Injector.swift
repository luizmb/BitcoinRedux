//
//  Injector.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 20.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public class Injector: InjectorProtocol {
    public static let shared: InjectorProtocol = {
        let global = Injector()
        return global
    }()

    public var mapper: Mapper = Mapper()
}
