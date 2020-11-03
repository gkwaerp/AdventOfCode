//
//  Day13VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 13/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day13VC: AoCVC, AdventDay, InputLoadable {
    class ArcadeMachine {
        enum GameObject: Int {
            case empty = 0
            case wall = 1
            case block = 2
            case horizontalPaddle = 3
            case ball = 4
            
            func asText() -> String {
                switch self {
                case .empty:
                    return "   "
                case .wall:
                    return " W "
                case .block:
                    return " B "
                case .horizontalPaddle:
                    return "---"
                case .ball:
                    return " * "
                }
            }
        }
        
        enum JoystickState: Int {
            case left = -1
            case neutral = 0
            case right = 1
        }
        
        let brain: IntMachine
        
        var gameBoard = [IntPoint: GameObject]()
        var currentScore = 0
        var ballPos: IntPoint?
        var paddlePos: IntPoint?
        
        init(program: [Int]) {
            self.brain = IntMachine(memory: program)
        }
        
        @discardableResult
        func run(freePlay: Bool = false) -> IntMachine.ProgramStatus {
            var output = [Int]()
            let applicationState = self.brain.run { (outputValue) in
                output.append(outputValue)
            }

            while !output.isEmpty {
                let x = output[0]
                let y = output[1]
                if x == -1 && y == 0 {
                    self.currentScore = output[2]
                } else {
                    let gameObject = GameObject(rawValue: output[2])!
                    self.gameBoard[IntPoint(x: x, y: y)] = gameObject
                }
                output = Array(output.dropFirst(3))
            }
            
            self.parseScreen()
//            self.drawScreen()
            
            return applicationState
        }
        
        func parseScreen() {
            let gridInfo = IntPoint.gridInfo(from: self.gameBoard.keys)
            let allPoints = gridInfo.allPoints
            for rawPoint in allPoints {
                let actualPoint = rawPoint + gridInfo.minExtents
                if let gameObject = self.gameBoard[actualPoint] {
                    if gameObject == .ball {
                        self.ballPos = actualPoint
                    } else if gameObject == .horizontalPaddle {
                        self.paddlePos = actualPoint
                    }
                }
            }
        }
        
        func drawScreen() {
            let gridInfo = IntPoint.gridInfo(from: self.gameBoard.keys)
            let allPoints = gridInfo.allPoints
            var prevY = -1
            var currString = "SCORE: \(self.currentScore)\n"
            for point in allPoints {
                if prevY != point.y {
                    currString.append("\n")
                    prevY = point.y
                }
                let gameObject = self.gameBoard[point] ?? .empty
                currString.append("\(gameObject.asText())")
            }
            currString.append("\n\n")
        }

        func reset(freePlay: Bool) {
            self.brain.reset()
            self.currentScore = 0
            if freePlay {
                self.brain.setMemoryDirect(memoryAddress: 0, value: 2)
            }
        }
    }

    private var arcadeMachine: ArcadeMachine!
    
    func loadInput() {
        let line = "Day13Input".loadAsTextStringArray().first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.arcadeMachine = ArcadeMachine(program: ints)
    }
    
    func solveFirst() {
        self.arcadeMachine.reset(freePlay: false)
        self.arcadeMachine.run()
        self.setSolution(challenge: 0, text: "\(self.arcadeMachine.gameBoard.values.filter({$0 == .block}).count)")
    }
    
    func solveSecond() {
        self.arcadeMachine.reset(freePlay: true)
        var isHalted = false
        while !isHalted {
            let applicationState = self.arcadeMachine.run(freePlay: true)
            switch applicationState {
            case .exitedSuccessfully:
                isHalted = true
            case .waitingForInput:
                let input = self.generateInput()
                self.arcadeMachine.brain.inputs.append(input)
            default: break
            }
        }
        self.setSolution(challenge: 1, text: "\(self.arcadeMachine.currentScore)")
    }
    
    func generateInput() -> Int {
        guard let ballPos = self.arcadeMachine.ballPos,
            let paddlePos = self.arcadeMachine.paddlePos else { return ArcadeMachine.JoystickState.neutral.rawValue }
        
        let delta = ballPos.x - paddlePos.x
        if delta > 0 {
            return ArcadeMachine.JoystickState.right.rawValue
        } else if delta < 0 {
            return ArcadeMachine.JoystickState.left.rawValue
        } else {
            return ArcadeMachine.JoystickState.neutral.rawValue
        }
    }
}
