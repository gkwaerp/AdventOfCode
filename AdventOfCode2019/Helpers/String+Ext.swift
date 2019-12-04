//
//  String+Ext.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 04/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

extension String {
    func toStringArray() -> [String] {
        return self.map({"\($0)"})
    }
}
