//
//  Day11VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 11/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day11VC: AoCVC, AdventDay {
    struct PaintRobot {
        enum Color: Int {
            case black = 0
            case white = 1
        }
        var surface = [IntPoint: Color]()

        enum Direction {
            case up, down, left, right

            mutating func turn(left: Bool) {
                switch self {
                case .up:
                    self = left ? .left : .right
                case .down:
                    self = left ? .right : .left
                case .left:
                    self = left ? .down : .up
                case .right:
                    self = left ? .up : .down
                }
            }

            var intPoint: IntPoint {
                switch self {
                case .up:
                    return IntPoint(x: 0, y: -1)
                case .down:
                    return IntPoint(x: 0, y: 1)
                case .left:
                    return IntPoint(x: -1, y: 0)
                case .right:
                    return IntPoint(x: 1, y: 0)
                }
            }
        }

        var currentDirection: Direction = .up
        var currentPosition: IntPoint = .origin

        func getCurrentColor() -> Color {
            return self.surface[self.currentPosition] ?? .black
        }

        mutating func reset() {
            self.surface = [:]
            self.currentDirection = .up
            self.currentPosition = .origin
        }

        mutating func paint(color: Color) {
            self.surface[self.currentPosition] = color
        }

        mutating func paint(_ rawValue: Int) {
            let color = Color(rawValue: rawValue)!
            self.paint(color: color)
        }

        mutating func turnAndMove(left: Bool) {
            self.currentDirection.turn(left: left)
            self.currentPosition += self.currentDirection.intPoint
        }

        func print() -> String {
            var minX = Int(INT_MAX)
            var maxX = Int(-INT_MAX)
            var minY = Int(INT_MAX)
            var maxY = Int(-INT_MAX)

            for key in self.surface.keys {
                minX = min(minX, key.x)
                maxX = max(maxX, key.x)
                minY = min(minY, key.y)
                maxY = max(maxY, key.y)
            }

            let minPoint = IntPoint(x: minX, y: minY)
            let maxPoint = IntPoint(x: maxX, y: maxY)
            let size = maxPoint - minPoint

            var finalString = "\n"
            for y in 0...size.y {
                for x in 0...size.x {
                    let rawPoint = IntPoint(x: x, y: y)
                    let actualPoint = rawPoint + minPoint
                    if self.surface[actualPoint] == .white {
                        finalString.append("X")
                    } else {
                        finalString.append(" ")
                    }
                }
                finalString.append("\n")
            }
            finalString.append("\n")

            return finalString
        }
    }

    let machine = IntMachine()
    var robot = PaintRobot()

    func loadInput() {
        let line = FileLoader.loadText(fileName: "Day11Input").first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.machine.loadNewProgram(memory: ints)
    }
    
    func solveFirst() {
        var finished = false
        while !finished {
            var isPainting = true
            let state = self.machine.run { (outputValue) in
                if isPainting {
                    self.robot.paint(outputValue)
                } else {
                    let left = outputValue == 0
                    self.robot.turnAndMove(left: left)
                }
                isPainting.toggle()
            }
            switch state {
            case .exitedSuccessfully:
                finished = true
            case .waitingForInput:
                machine.inputs.append(self.robot.getCurrentColor().rawValue)
            default: break
            }
        }

        self.setSolution1("\(self.robot.surface.count)")
    }
    
    func solveSecond() {
        self.machine.reset()
        self.robot.reset()
        self.robot.paint(color: .white)

        var finished = false
        while !finished {
            var isPainting = true
            let state = self.machine.run { (outputValue) in
                if isPainting {
                    self.robot.paint(outputValue)
                } else {
                    let left = outputValue == 0
                    self.robot.turnAndMove(left: left)
                }
                isPainting.toggle()
            }
            switch state {
            case .exitedSuccessfully:
                finished = true
            case .waitingForInput:
                machine.inputs.append(self.robot.getCurrentColor().rawValue)
            default: break
            }
        }

        self.setSolution2(self.robot.print())
    }
}
