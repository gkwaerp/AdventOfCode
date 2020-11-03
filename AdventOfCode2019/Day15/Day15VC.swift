//
//  Day15VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 15/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day15VC: AoCVC, AdventDay, InputLoadable {
    class RepairDroid {
        enum DroidStatus: Int {
            case hitWall = 0
            case moved = 1
            case foundOxygen = 2
        }
        
        enum MapTile {
            case empty
            case wall
            case oxygen
        }
        
        var mazeMap = [IntPoint: MapTile]() // Coordinate --> Tile
        
        let brain = IntMachine()
        var currentPosition = IntPoint.origin
        var attemptedPosition: IntPoint!
        var attemptedDirection: Direction!
        var potentialLocations = Set<IntPoint>()
        var backtrackHistory = [Direction]()
        
        init(program: [Int]) {
            self.brain.loadNewProgram(memory: program)
        }
        
        func run() {
            self.mazeMap[self.currentPosition] = .empty
            self.addSurrondingsToPotentials()
            var isHalted = false
            while !isHalted {
                let programState = self.brain.run { (outputValue) in
                    self.handleOutput(output: outputValue)
                    if self.potentialLocations.isEmpty {
                        isHalted = true
                    }
                }
                
                switch programState {
                case .waitingForInput:
                    self.applyInput()
                case .exitedSuccessfully:
                    isHalted = true
                default: break
                }
            }
            self.drawMap()
        }
        
        func handleOutput(output: Int) {
            let droidStatus = DroidStatus(rawValue: output)!
            self.potentialLocations.remove(self.attemptedPosition)
            
            switch droidStatus {
            case .moved, .foundOxygen:
                self.currentPosition = self.attemptedPosition
                if self.mazeMap[self.attemptedPosition] == nil {
                    self.mazeMap[self.attemptedPosition] = (droidStatus == .moved) ? .empty : .oxygen
                    self.backtrackHistory.append(self.attemptedDirection)
                    self.addSurrondingsToPotentials()
                }
            case .hitWall:
                self.mazeMap[self.attemptedPosition] = .wall
            }
        }
        
        func applyInput() {
            for direction in Direction.allCases {
                let newPos = self.currentPosition + direction.movementVector
                if self.potentialLocations.contains(newPos) {
                    self.attemptedPosition = newPos
                    self.attemptedDirection = direction
                    self.brain.inputs.append(direction.rawValue)
                    return
                }
            }
            let backTrackDirection = self.backtrackHistory.popLast()!.reversed
            self.attemptedPosition = self.currentPosition + backTrackDirection.movementVector
            self.attemptedDirection = backTrackDirection
            self.brain.inputs.append(backTrackDirection.rawValue)
        }
        
        func drawMap() {
            let gridInfo = IntPoint.gridInfo(from: self.mazeMap.keys)
            let allPoints = gridInfo.allPoints
            var prevY: Int? = nil
            var mapString = "------------------------------------------------------\n"
            for point in allPoints {
                if prevY != point.y {
                    mapString.append("\n")
                    prevY = point.y
                }
                if point == IntPoint.origin {
                    mapString.append("S")
                } else if point == self.currentPosition {
                    mapString.append("D")
                } else {
                    if let mapTile = self.mazeMap[point] {
                        switch mapTile {
                        case .empty: mapString.append(".")
                        case .oxygen: mapString.append("O")
                        case .wall: mapString.append("#")
                        }
                    } else {
                        mapString.append(" ")
                    }
                }
            }
            
            print(mapString)
        }
        
        func addSurrondingsToPotentials() {
            for direction in Direction.allCases {
                let newPos = self.currentPosition + direction.movementVector
                if self.mazeMap[newPos] == nil {
                    self.potentialLocations.insert(newPos)
                }
            }
        }
    }
    
    var repairDroid: RepairDroid!
    
    func loadInput() {
        let lines = "Day15Input".loadAsTextStringArray().first!.components(separatedBy: ",")
        let memory = lines.map({Int($0)!})
        self.repairDroid = RepairDroid(program: memory)
    }
    
    private var aStar = IntAStar()
    
    func solveFirst() {
        self.repairDroid.run()
        
        // Backwards, since part 2 wants to find longest from oxygen to anywhere.
        let start = self.repairDroid.mazeMap.first(where: {$0.value == .oxygen})!.key
        let end = IntPoint.origin
        var nodes = Set<AStarNode>()
        for (point, tile) in self.repairDroid.mazeMap {
            switch tile {
            case .wall: break
            default: nodes.insert(AStarNode(position: point))
            }
        }
        
        for node in nodes {
            for direction in Direction.allCases {
                let newPosition = node.position + direction.movementVector
                if let newTile = self.repairDroid.mazeMap.first(where: {$0.key == newPosition}) {
                    switch newTile.value {
                    case .wall: break
                    default:
                        let newNode = nodes.first(where: {$0.position == newPosition})!
                        node.edges.insert(AStarEdge(from: node, to: newNode, cost: 1))
                    }
                }
            }
        }
        
        let startNode = nodes.first(where: {$0.position == start})!
        
        self.aStar.computeShortestPaths(startNode: startNode)
        let node = self.aStar.closed.first(where: {$0.position == end})!
        
        self.setSolution(challenge: 0, text: "\(node.g)")
    }
    
    func solveSecond() {
        let maxPathLength = self.aStar.closed.max(by: {$0.g < $1.g})!.g
        self.setSolution(challenge: 1, text: "\(maxPathLength)")
    }
}
