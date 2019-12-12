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

// Source: https://github.com/raywenderlich/swift-algorithm-club/tree/master/GCD
extension Math {
    static func greatestCommonDivisorIterativeEuklid(_ m: Int, _ n: Int) -> Int {
        var a: Int = 0
        var b: Int = max(m, n)
        var r: Int = min(m, n)
        
        while r != 0 {
            a = b
            b = r
            r = a % b
        }
        return b
    }

    static func leastCommonMultiple(_ m: Int, _ n: Int) -> Int {
        guard (m & n) != 0 else { fatalError() }
        return m / greatestCommonDivisorIterativeEuklid(m, n) * n
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
