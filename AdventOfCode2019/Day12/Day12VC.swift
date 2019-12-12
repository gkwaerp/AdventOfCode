//
//  Day12VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 12/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day12VC: AoCVC, AdventDay {
    struct Moon {
        struct VelPos: Equatable {
            var vel: Int
            var pos: Int
        }
        
        private let initialX: VelPos
        private let initialY: VelPos
        private let initialZ: VelPos

        var x: VelPos!
        var y: VelPos!
        var z: VelPos!
        
        init(x: Int, y: Int, z: Int) {
            self.initialX = VelPos(vel: 0, pos: x)
            self.initialY = VelPos(vel: 0, pos: y)
            self.initialZ = VelPos(vel: 0, pos: z)
            self.reset()
        }

        mutating func reset() {
            self.x = self.initialX
            self.y = self.initialY
            self.z = self.initialZ
        }
        
        mutating func calcX(otherMoons: [Moon]) {
            for other in otherMoons {
                let delta = other.x.pos - self.x.pos
                if delta > 0 {
                    self.x.vel += 1
                } else if delta < 0 {
                    self.x.vel -= 1
                }
            }
            self.x.pos += self.x.vel
        }
        
        mutating func calcY(otherMoons: [Moon]) {
            for other in otherMoons {
                let delta = other.y.pos - self.y.pos
                if delta > 0 {
                    self.y.vel += 1
                } else if delta < 0 {
                    self.y.vel -= 1
                }
            }
            self.y.pos += self.y.vel
        }
        
        mutating func calcZ(otherMoons: [Moon]) {
            for other in otherMoons {
                let delta = other.z.pos - self.z.pos
                if delta > 0 {
                    self.z.vel += 1
                } else if delta < 0 {
                    self.z.vel -= 1
                }
            }
            self.z.pos += self.z.vel
        }

        var sameAsInitial: Bool {
            return self.x == self.initialX && self.y == self.initialY && self.z == self.initialZ
        }
        
        func totalEnergy() -> Int {
            let pot = abs(self.x.pos) + abs(self.y.pos) + abs(self.z.pos)
            let kin = abs(self.x.vel) + abs(self.y.vel) + abs(self.z.vel)
            return pot * kin
        }
    }
    
    private var moons = [Moon]()
    
    func loadInput() {
        let lines = FileLoader.loadText(fileName: "Day12Input")
            .map({$0.replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: ">", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "=", with: "")})
        for line in lines {
            let split = line.split(separator: ",")
            let x = Int("\(split[0])".replacingOccurrences(of: "x", with: ""))!
            let y = Int("\(split[1])".replacingOccurrences(of: "y", with: ""))!
            let z = Int("\(split[2])".replacingOccurrences(of: "z", with: ""))!
            self.moons.append(Moon(x: x, y: y, z: z))
        }
    }
    
    func solveFirst() {
        let count = self.moons.count
        for _ in 0..<1000 {
            let moonsCopy = self.moons
            for index in 0..<count {
                self.moons[index].calcX(otherMoons: moonsCopy)
                self.moons[index].calcY(otherMoons: moonsCopy)
                self.moons[index].calcZ(otherMoons: moonsCopy)
            }
        }
        self.setSolution1("\(moons.reduce(0, {$0 + $1.totalEnergy()}))")
    }
    
    func solveSecond() {
        var numSteps = [0, 0, 0]
        for axisIndex in 0..<numSteps.count {
            for moonIndex in 0..<self.moons.count {
                self.moons[moonIndex].reset()
            }

            var finished = false
            while !finished {
                let moonsCopy = self.moons
                for moonIndex in 0..<self.moons.count {
                    if axisIndex == 0 {
                        self.moons[moonIndex].calcX(otherMoons: moonsCopy)
                    } else if axisIndex == 1 {
                        self.moons[moonIndex].calcY(otherMoons: moonsCopy)
                    } else {
                        self.moons[moonIndex].calcZ(otherMoons: moonsCopy)
                    }
                }
                numSteps[axisIndex] += 1
                finished = self.moons.allSatisfy({$0.sameAsInitial})
            }
        }
        let leastCommonMultiple = numSteps.reduce(numSteps.first!, {Math.leastCommonMultiple($0, $1)})
        self.setSolution2("\(leastCommonMultiple)")
    }
}
