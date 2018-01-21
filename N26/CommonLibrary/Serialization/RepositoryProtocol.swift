//
//  RepositoryProtocol.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public protocol RepositoryProtocol {
    func save(data: Data, filename: String)
    func load(filename: String) -> Result<Data>
}
