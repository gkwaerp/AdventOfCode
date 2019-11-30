//
//  FileLoader.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 30/11/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

class FileLoader {
    private static func getData(for fileName: String, fileType: String?) -> Data {
        return try! Data(contentsOf: getURL(for: fileName, fileType: fileType))
    }

    private static func getURL(for fileName: String, fileType: String?) -> URL {
        let path = Bundle.main.path(forResource: fileName, ofType: fileType)!
        return URL(fileURLWithPath: path)
    }

    static func loadJSON<T: Codable>(fileName: String, fileType: String? = nil, parseType: T.Type) -> T {
        let data = getData(for: fileName, fileType: fileType)
        return try! JSONDecoder().decode(T.self, from: data)
    }

    static func loadText(fileName: String, fileType: String? = nil) -> [String] {
        return try! String(contentsOf: getURL(for: fileName, fileType: fileType), encoding: .utf8).components(separatedBy: "\n")
    }
}
