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
    
    static func scaling(_ a: IntPoint, s: Int) -> IntPoint {
        return scaling(a, sx: s, sy: s)
    }
    
    static func scaling(_ a: IntPoint, sx: Int, sy: Int) -> IntPoint {
        return IntPoint(x: a.x * sx, y: a.y * sy)
    }
    
    static var origin: IntPoint {
        return IntPoint(x: 0, y: 0)
    }

    static func angle(between a: IntPoint, and b: IntPoint, invertY: Bool) -> Double? {
        let delta = IntPoint.subtracting(b, a)
        if delta.x == 0 && delta.y == 0 {
            return nil
        }

        let x = Double(delta.x)
        let y = invertY ? Double(-delta.y) : Double(delta.y)
        return atan2(x, y)
    }

    static func angleInDegrees(between a: IntPoint, and b: IntPoint, invertY: Bool) -> Double? {
        guard let radians = IntPoint.angle(between: a, and: b, invertY: invertY) else { return nil }
        return (radians * 180.0 / Double.pi)
    }
}
