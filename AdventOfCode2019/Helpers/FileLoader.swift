//
//  FileLoader.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 30/11/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

class FileLoader {
    static func loadJSON<T: Decodable>(fileName: String, fileType: String? = nil, parseType: T.Type) -> T {
        let jsonDecoder = JSONDecoder()
        let path = Bundle.main.path(forResource: fileName, ofType: fileType)!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        return try! jsonDecoder.decode(T.self, from: data)
    }
}
