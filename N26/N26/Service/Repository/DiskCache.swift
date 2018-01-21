//
//  DiskCache.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import CommonLibrary

public enum FileError: Error {
    case notFound
}

public class DiskCache: RepositoryProtocol {
    static let shared: RepositoryProtocol = {
        let global = DiskCache()
        return global
    }()

    public func save(data: Data, name: String) {
        guard let path = documentsFolder?.appendingPathComponent("\(name).bin") else { return }
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }

    public func load(name: String) -> Result<Data> {
        guard let path = documentsFolder?.appendingPathComponent("\(name).bin"),
            let data = FileManager.default.contents(atPath: path) else {
                return .error(FileError.notFound)
        }

        return .success(data)
    }

    private var documentsFolder: String? {
        let f = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appendingPathComponent("BitcoinRatesCache")
        do {
            try FileManager.default.createDirectory(atPath: f, withIntermediateDirectories: true, attributes: nil)
            return f
        } catch {
            return nil
        }
    }
}
