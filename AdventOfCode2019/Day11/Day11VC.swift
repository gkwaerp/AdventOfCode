//
//  Day11VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 11/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day11VC: AoCVC, AdventDay {
    class PaintRobot {
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
        }
        
        enum State {
            case painting
            case moving
        }

        private let brain: IntMachine
        var surface = [IntPoint: Color]()

        private var currentDirection: Direction = .up
        private var currentPosition: IntPoint = .origin
        private var currentState: State = .painting
        
        init(program: [Int]) {
            self.brain = IntMachine(memory: program)
        }

        func reset() {
            self.surface = [:]
            self.currentDirection = .up
            self.currentPosition = .origin
            self.brain.reset()
        }

        func getCurrentColor() -> Color {
            return self.getColor(at: self.currentPosition)
        }

        func getColor(at point: IntPoint) -> Color {
            return self.surface[point] ?? .black
        }

        private func paint(color: Color) {
            self.setColor(color, at: self.currentPosition)
        }

        func setColor(_ color: Color, at point: IntPoint) {
            self.surface[point] = color
        }

        func paint(_ rawValue: Int) {
            let color = Color(rawValue: rawValue)!
            self.paint(color: color)
        }
        
        func turn(left: Bool) {
            self.currentDirection.turn(left: left)
        }
        
        private func move() {
            self.currentPosition += self.currentDirection.movementVector
        }
        
        func run() {
            var finished = false
            while !finished {
                let brainState = self.brain.run { (outputValue) in
                    self.handleAction(value: outputValue)
                }

                switch brainState {
                case .exitedSuccessfully:
                    finished = true
                case .waitingForInput:
                    self.brain.inputs.append(self.getCurrentColor().rawValue)
                default: break
                }
            }
        }

        private func handleAction(value: Int) {
            switch self.currentState {
            case .painting:
                self.paint(value)
                self.currentState = .moving
            case .moving:
                let left = value == 0
                self.turn(left: left)
                self.move()
                self.currentState = .painting
            }
        }

        func print() -> String {
            let gridInfo = IntPoint.gridInfo(from: self.surface.keys)

            let allGridPoints = IntPoint.gridPoints(x: gridInfo.width, y: gridInfo.height)
            let pixels = allGridPoints.map { (rawPoint) -> Color in
                let actualPoint = rawPoint + gridInfo.minExtents
                return getColor(at: actualPoint)
            }

            let image = IntImage(width: gridInfo.width, height: gridInfo.height, pixels: pixels)
            return image.rasterized.asText()
        }
    }

    var robot: PaintRobot!

    func loadInput() {
        let line = FileLoader.loadText(fileName: "Day11Input").first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.robot = PaintRobot(program: ints)
    }
    
    func solveFirst() {
        self.robot.run()
        self.setSolution1("\(self.robot.surface.count)")
    }
    
    func solveSecond() {
        self.robot.reset()
        self.robot.setColor(.white, at: .origin)
        self.robot.run()

        self.setSolution2(self.robot.print())
    }
}
