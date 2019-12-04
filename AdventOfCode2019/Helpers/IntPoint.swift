//
//  IntPoint.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

struct IntPoint: Hashable {
    let x: Int
    let y: Int
    
    func manhattanDistance(to other: IntPoint = .origin) -> Int {
        return abs(self.x - other.x) + abs(self.y - other.y)
    }
    
    static func adding(_ a: IntPoint, _ b: IntPoint) -> IntPoint {
        return IntPoint(x: a.x + b.x, y: a.y + b.y)
    }

    static func subtracting(_ a: IntPoint, _ b: IntPoint) -> IntPoint {
        return IntPoint(x: a.x - b.x, y: a.y - b.y)
    }
    
    static var origin: IntPoint {
        return IntPoint(x: 0, y: 0)
    }
}
