//
//  Math.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

class Math {
    static func lerp<T: FloatingPoint>(a: T, b: T, alpha: T) -> T {
        return (1 - alpha) * a + b * alpha
    }
}

extension Comparable {
    func clamp(between a: Self, and b: Self) -> Self {
        let min = Swift.min(a, b)
        let max = Swift.max(a, b)
        return Swift.min(Swift.max(self, min), max)
    }

    func clamp(min: Self) -> Self {
        return Swift.max(min, self)
    }

    func clamp(max: Self) -> Self {
        return Swift.min(max, self)
    }
}
