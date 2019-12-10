//
//  Day10VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 10/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day10VC: AoCVC, AdventDay {
    class Asteroid {
        let point: IntPoint
        var observables = [Double: [IntPoint]]() // angle --> points at that angle. Points sorted by distance, ascending.

        init(point: IntPoint) {
            self.point = point
        }

        func populate(allAsteroids: [Asteroid]) {
            for asteroid in allAsteroids {
                if let rawAngle = IntPoint.angle(between: self.point, and: asteroid.point, invertY: true) {
                    let angle = (rawAngle + 2 * Double.pi).truncatingRemainder(dividingBy: 2 * Double.pi)
                    if self.observables[angle] == nil {
                        self.observables[angle] = [IntPoint]()
                    }
                    let distanceToPoint = self.point.manhattanDistance(to: asteroid.point)
                    let insertionIndex = self.observables[angle]!.insertionIndex(for: {$0.manhattanDistance(to: self.point) < distanceToPoint })
                    self.observables[angle]!.insert(asteroid.point, at: insertionIndex)
                }
            }
        }

        func getObservableCount(others: [Asteroid]) -> Int {
            return self.observables.keys.count
        }

        func destroyOthers(numToDestroy: Int) -> IntPoint {
            let sortedAngles = self.observables.keys.sorted(by: <)
            var currAngleIndex = 0
            var numDestroyed = 0
            var lastDestroyed: IntPoint!
            while numDestroyed < numToDestroy {
                let currAngle = sortedAngles[currAngleIndex]
                let currArray = self.observables[currAngle]!
                currAngleIndex += 1
                currAngleIndex %= sortedAngles.count
                guard !currArray.isEmpty else { continue }
                lastDestroyed = currArray.first!
                self.observables[currAngle]!.remove(at: 0)
                numDestroyed += 1
            }
            
            return lastDestroyed
        }
    }

    private var asteroids = [Asteroid]()
    func loadInput() {
        let lines = FileLoader.loadText(fileName: "Day10Input")
        for (y, line) in lines.enumerated() {
            let chars = line.toStringArray()
            for (x, char) in chars.enumerated() {
                if char == "#" {
                    self.asteroids.append(Asteroid(point: IntPoint(x: x, y: y)))
                }
            }
        }

        for asteroid in self.asteroids {
            asteroid.populate(allAsteroids: self.asteroids)
        }
    }

    private var bestAsteroid: Asteroid!
    
    func solveFirst() {
        var bestCount = 0
        for asteroid in self.asteroids {
            let count = asteroid.getObservableCount(others: self.asteroids)
            if count > bestCount {
                bestCount = count
                self.bestAsteroid = asteroid
            }
        }
        self.setSolution1("\(bestCount)")
    }
    
    func solveSecond() {
        let lastDestroyed = bestAsteroid.destroyOthers(numToDestroy: 200)
        self.setSolution2("\(lastDestroyed.x * 100 + lastDestroyed.y)")
    }
}
