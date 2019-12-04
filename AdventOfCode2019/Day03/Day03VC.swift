//
//  Day03VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day03VC: AoCVC, AdventDay {
    struct WirePath {
        private var dictionary = [IntPoint: Int]()
        private var points = Set<IntPoint>()
        
        var numStepsSoFar = 0
        private mutating func addPoint(_ point: IntPoint) {
            numStepsSoFar += 1
            if self.points.insert(point).inserted {
                self.dictionary[point] = numStepsSoFar
            }
        }
        
        init(string: String) {
            let components = string.components(separatedBy: ",")
            var currPoint = IntPoint(x: 0, y: 0)
            for component in components {
                let directionString = component.first!
                let numSteps = Int(component.dropFirst())!
                
                var direction: IntPoint!
                switch directionString {
                case "U": direction = IntPoint(x: 0, y: 1)
                case "D": direction = IntPoint(x: 0, y: -1)
                case "L": direction = IntPoint(x: -1, y: 0)
                case "R": direction = IntPoint(x: 1, y: 0)
                default: fatalError()
                }
                
                for _ in 0..<numSteps {
                    currPoint = IntPoint.adding(currPoint, direction)
                    self.addPoint(currPoint)
                }
            }
        }
        
        func intersections(with otherPath: WirePath) -> Set<IntPoint> {
            return self.points.intersection(otherPath.points)
        }
        
        func stepsToIntersection(point: IntPoint) -> Int {
            return self.dictionary[point]!
        }
    }
    
    private var wirePaths = [WirePath]()
    
    func loadInput() {
        self.wirePaths = FileLoader.loadText(fileName: "Day03Input").map({WirePath(string: $0)})
    }
    
    func solveFirst() {
        let intersections = self.wirePaths[0].intersections(with: self.wirePaths[1])
        let closest = intersections.map({$0.manhattanDistance(to: .origin)}).sorted().first!
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
