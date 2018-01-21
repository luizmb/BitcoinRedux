//
//  DiskCache.swift
//  N26
//
//  Created by Luiz Rodrigo Martins Barbosa on 21.01.18.
//  Copyright © 2018 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation

public enum FileError: Error {
    case notFound
}

public class DiskCache: RepositoryProtocol {
    public init() { }

    public func save(data: Data, filename: String) {
        guard let path = documentsFolder?.appendingPathComponent(filename) else { return }
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }

    public func load(filename: String) -> Result<Data> {
        guard let path = documentsFolder?.appendingPathComponent(filename),
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
