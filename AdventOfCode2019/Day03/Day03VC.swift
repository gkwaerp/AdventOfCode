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
                let direction = component.first!
                let numSteps = Int(component.dropFirst())!
                
                var directionalPoint: IntPoint!
                switch direction {
                case "U": directionalPoint = IntPoint(x: 0, y: 1)
                case "D": directionalPoint = IntPoint(x: 0, y: -1)
                case "L": directionalPoint = IntPoint(x: -1, y: 0)
                case "R": directionalPoint = IntPoint(x: 1, y: 0)
                default: fatalError()
                }
                
                for _ in 0..<numSteps {
                    currPoint = IntPoint.adding(currPoint, directionalPoint)
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
