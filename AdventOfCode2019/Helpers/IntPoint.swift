//
//  IntPoint.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

struct IntPoint: Equatable, Hashable {
    let x: Int
    let y: Int
    
    static var origin: IntPoint {
        return IntPoint(x: 0, y: 0)
    }
    
    func manhattanDistance(to other: IntPoint) -> Int {
        return abs(self.x - other.x) + abs(self.y - other.y)
    }
    
    func scaling(s: Int) -> IntPoint {
        return self.scaling(sx: s, sy: s)
    }
    
    func scaling(sx: Int, sy: Int) -> IntPoint {
        return IntPoint(x: self.x * sx, y: self.y * sy)
    }
    
    static func +(lhs: IntPoint, rhs: IntPoint) -> IntPoint {
        return IntPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: IntPoint, rhs: IntPoint) -> IntPoint {
        return IntPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +=(lhs: inout IntPoint, rhs: IntPoint) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout IntPoint, rhs: IntPoint) {
        lhs = lhs - rhs
    }
    
    static func angle(between a: IntPoint, and b: IntPoint, invertY: Bool) -> Double? {
        guard a != b else { return nil }
        let delta = b - a
        let x = Double(delta.x)
        let y = invertY ? Double(-delta.y) : Double(delta.y)
        return atan2(x, y)
    }
    
    static func angleInDegrees(between a: IntPoint, and b: IntPoint, invertY: Bool) -> Double? {
        guard let radians = IntPoint.angle(between: a, and: b, invertY: invertY) else { return nil }
        return (radians * 180.0 / Double.pi)
    }
}
