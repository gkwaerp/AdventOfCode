//
//  Direction.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 11/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

enum Direction: Int, CaseIterable {
    case up, left, down, right

    mutating func turn(left: Bool) {
        let offset = left ? 1 : Direction.allCases.count - 1
        let newRawValue = (self.rawValue + offset) % Direction.allCases.count
        self = Direction(rawValue: newRawValue)!
    }

    var movementVector: IntPoint {
        switch self {
        case .up: return IntPoint(x: 0, y: -1)
        case .down: return IntPoint(x: 0, y: 1)
        case .left: return IntPoint(x: -1, y: 0)
        case .right: return IntPoint(x: 1, y: 0)
        }
    }

    static func from(string: String) -> Direction {
        switch string {
        case "U": return .up
        case "D": return .down
        case "L": return .left
        case "R": return .right
        default: fatalError()
        }
    }
}
