//
//  Day06VC_2018.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 12/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day06VC_2018: AoCVC, AdventDay, InputLoadable {
    private var coordinates = [IntPoint]()
    func loadInput() {
        let input = "Day06Input_2018".loadAsTextStringArray()
        for line in input {
            let split = line.replacingOccurrences(of: " ", with: "").split(separator: ",")
            let x = Int(split[0])!
            let y = Int(split[1])!
            self.coordinates.append(IntPoint(x: x, y: y))
        }
    }
    
    func solveFirst() {
        let gridInfo = IntPoint.gridInfo(from: self.coordinates)
        let allPoints = gridInfo.allPoints

        var dictionary = [IntPoint: (IntPoint, Int)]() // Gridpoint --> closest coordinate & distance. Nil if multiple share same distance.
        for point in allPoints {
            var shortestDistance = Int.max
            var bestCoordinate: IntPoint? = nil
            for coordinate in self.coordinates {
                let distance = point.manhattanDistance(to: coordinate)
                if distance < shortestDistance {
                    shortestDistance = distance
                    bestCoordinate = coordinate
                } else if distance == shortestDistance {
                    bestCoordinate = nil
                }
            }
            if let bestCoordinate = bestCoordinate {
                dictionary[point] = (bestCoordinate, shortestDistance)
            }
        }

        var infiniteCoordinates = Set<IntPoint>()
        for y in 0..<gridInfo.height {
            let xMin = 0
            let xMax = gridInfo.width - 1
            let minPoint = IntPoint(x: xMin, y: y) + gridInfo.minExtents
            let maxPoint = IntPoint(x: xMax, y: y) + gridInfo.minExtents
            if let bestCoordinateInfo = dictionary[minPoint] {
                infiniteCoordinates.insert(bestCoordinateInfo.0)
            }
            if let bestCoordinateInfo = dictionary[maxPoint] {
                infiniteCoordinates.insert(bestCoordinateInfo.0)
            }
        }

        for x in 0..<gridInfo.width {
            let yMin = 0
            let yMax = gridInfo.height - 1
            let minPoint = IntPoint(x: x, y: yMin) + gridInfo.minExtents
            let maxPoint = IntPoint(x: x, y: yMax) + gridInfo.minExtents
            if let bestCoordinateInfo = dictionary[minPoint] {
                infiniteCoordinates.insert(bestCoordinateInfo.0)
            }
            if let bestCoordinateInfo = dictionary[maxPoint] {
                infiniteCoordinates.insert(bestCoordinateInfo.0)
            }
        }

        let finiteCoordinates = self.coordinates.filter({!infiniteCoordinates.contains($0)})
        let best = finiteCoordinates.map { (coordinate) -> Int in
            dictionary.values.map({$0.0 == coordinate}).filter({$0}).count
        }.max()!

        self.setSolution(challenge: 0, text: "\(best)")
    }
    
    func solveSecond() {
    }
}
