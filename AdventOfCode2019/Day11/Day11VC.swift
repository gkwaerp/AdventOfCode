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
        private enum State {
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
                    self.brain.inputs.append(self.getColor(at: self.currentPosition).rawValue)
                default: break
                }
            }
        }
        
        private func handleAction(value: Int) {
            switch self.currentState {
            case .painting:
                self.setColor(Color(rawValue: value)!, at: self.currentPosition)
                self.currentState = .moving
            case .moving:
                let left = value == 0
                self.turn(left: left)
                self.move()
                self.currentState = .painting
            }
        }
        
        private func getColor(at point: IntPoint) -> Color {
            return self.surface[point] ?? .black
        }
        
        func setColor(_ color: Color, at point: IntPoint) {
            self.surface[point] = color
        }
        
        private func move() {
            self.currentPosition += self.currentDirection.movementVector
        }

        private func turn(left: Bool) {
            self.currentDirection.turn(left: left)
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
    
    private var robot: PaintRobot!
    
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
