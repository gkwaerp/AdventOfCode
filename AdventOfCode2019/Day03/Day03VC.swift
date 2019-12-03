//
//  Day03VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day03VC: AoCVC, AdventDay {
    struct WirePoint: Hashable {
        let x: Int
        let y: Int
        
        func distance(to other: WirePoint = .origin) -> Int {
            return abs(self.x - other.x) + abs(self.y - other.y)
        }
        
        static func adding(_ a: WirePoint, _ b: WirePoint) -> WirePoint {
            return WirePoint(x: a.x + b.x, y: a.y + b.y)
        }
        
        static var origin: WirePoint {
            return WirePoint(x: 0, y: 0)
        }
    }
    
    struct WirePath {
        private var dictionary = [WirePoint: Int]()
        private var points = Set<WirePoint>()
        
        var numStepsSoFar = 0
        private mutating func addPoint(_ point: WirePoint) {
            numStepsSoFar += 1
            self.points.insert(point)
            if self.dictionary[point] == nil {
                self.dictionary[point] = numStepsSoFar
            }
        }
        
        init(string: String) {
            let components = string.components(separatedBy: ",")
            var currPoint = WirePoint(x: 0, y: 0)
            for component in components {
                let direction = component.first!
                let numSteps = Int(component.dropFirst())!
                
                var directionalPoint: WirePoint!
                switch direction {
                case "U": directionalPoint = WirePoint(x: 0, y: 1)
                case "D": directionalPoint = WirePoint(x: 0, y: -1)
                case "L": directionalPoint = WirePoint(x: -1, y: 0)
                case "R": directionalPoint = WirePoint(x: 1, y: 0)
                default: fatalError()
                }
                
                for _ in 0..<numSteps {
                    currPoint = WirePoint.adding(currPoint, directionalPoint)
                    self.addPoint(currPoint)
                }
            }
        }
        
        func intersections(with otherPath: WirePath) -> Set<WirePoint> {
            return self.points.intersection(otherPath.points)
        }
        
        func stepsToIntersection(point: WirePoint) -> Int {
            return self.dictionary[point]!
        }
    }
    
    private var wirePaths = [WirePath]()
    
    func loadInput() {
        self.wirePaths = FileLoader.loadText(fileName: "Day03Input").map({WirePath(string: $0)})
    }
    
    func solveFirst() {
        let intersections = self.wirePaths[0].intersections(with: self.wirePaths[1])
        let closest = intersections.map({$0.distance(to: .origin)}).sorted().first!
        self.setSolution1("\(closest)")
    }
    
    func solveSecond() {
        let intersections = self.wirePaths[0].intersections(with: self.wirePaths[1])
        let totalSteps = intersections.map { (intersection) in
            self.wirePaths.map({$0.stepsToIntersection(point: intersection)}).reduce(0, +)
        }.sorted().first!
        self.setSolution2("\(totalSteps)")
    }
}
