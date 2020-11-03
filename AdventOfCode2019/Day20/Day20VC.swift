//
//  Day20VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 21/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day20VC: AoCVC, AdventDay, InputLoadable {
    enum MazeTile {
        case empty
        case wall
        case teleporter(id: String)
        case label(id: String)
    }
    
    var mazeMap = [IntPoint: MazeTile]()
    var startPosition: IntPoint!
    var endPosition: IntPoint!
    var teleporterLocations = [String: [IntPoint]]()
    
    
    func loadInput() {
        let lines = "Day20Input".loadAsTextStringArray()
        
        var y = 0
        for line in lines {
            var x = 0
            for character in line {
                let position = IntPoint(x: x, y: y)
                x += 1
                
                let stringedCharacter = "\(character)"
                guard !stringedCharacter.isEmpty else { continue }
                
                switch stringedCharacter {
                case "#": self.mazeMap[position] = .wall
                case ".": self.mazeMap[position] = .empty
                case " ": break
                default: self.mazeMap[position] = .label(id: stringedCharacter)
                }
            }
            y += 1
        }
        
        self.parseMaze()
    }
    
    func parseMaze() {
        let gridInfo = IntPoint.gridInfo(from: self.mazeMap.keys)
        for point in gridInfo.allPoints {
            if let id = self.getIdForPosition(point) {
                for direction in [Direction.east, Direction.south] {
                    if let otherId = self.getIdForPosition(point + direction.movementVector) {
                        let posBeyond = point + direction.movementVector.scaled(by: 2)
                        let posBefore = point + direction.movementVector.scaled(by: -1)
                        if let beyondTile = self.mazeMap[posBeyond] {
                            switch beyondTile {
                            case .empty:
                                if id == "A" && otherId == "A" {
                                    self.startPosition = posBeyond
                                } else if id == "Z" && otherId == "Z" {
                                    self.endPosition = posBeyond
                                } else {
                                    let teleporterId = "\(id)\(otherId)"
                                    self.mazeMap[posBeyond] = .teleporter(id: teleporterId)
                                    if self.teleporterLocations[teleporterId] == nil {
                                        self.teleporterLocations[teleporterId] = []
                                    }
                                    self.teleporterLocations[teleporterId]!.append(posBeyond)
                                }
                            default: break
                            }
                        } else if let beforeTile = self.mazeMap[posBefore] {
                            switch beforeTile {
                            case .empty:
                                if id == "A" && otherId == "A" {
                                    self.startPosition = posBefore
                                } else if id == "Z" && otherId == "Z" {
                                    self.endPosition = posBefore
                                } else {
                                    let teleporterId = "\(id)\(otherId)"
                                    self.mazeMap[posBefore] = .teleporter(id: teleporterId)
                                    if self.teleporterLocations[teleporterId] == nil {
                                        self.teleporterLocations[teleporterId] = []
                                    }
                                    self.teleporterLocations[teleporterId]!.append(posBefore)
                                }
                            default: break
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getIdForPosition(_ position: IntPoint) -> String? {
        if let tile = self.mazeMap[position] {
            switch tile {
            case .label(let id):
                return id
            default: return nil
            }
        }
        return nil
    }
    
    
    func solveFirst() {
        var teleporters = [IntPoint: String]()
        let aStar = IntAStar()
        var nodes = Set<AStarNode>()
        for (position, tile) in self.mazeMap {
            switch tile {
            case .wall, .label: break
            case .empty:
                nodes.insert(AStarNode(position: position))
            case .teleporter(let id):
                nodes.insert(AStarNode(position: position))
                teleporters[position] = id
            }
        }
        
        for node in nodes {
            for direction in Direction.allCases {
                let newPosition = node.position + direction.movementVector
                if let newTile = self.mazeMap.first(where: {$0.key == newPosition}) {
                    switch newTile.value {
                    case .wall, .label: break
                    default:
                        let newNode = nodes.first(where: {$0.position == newPosition})!
                        node.edges.insert(AStarEdge(from: node, to: newNode, cost: 1))
                    }
                }
            }
        }
        
        for (position, id) in teleporters {
            let endPosition = teleporters.first(where: {$0.value == id && $0.key != position})!.key
            let startTeleporterNode = nodes.first(where: {$0.position == position})!
            let endTeleporterNode = nodes.first(where: {$0.position == endPosition})!
            startTeleporterNode.edges.insert(AStarEdge(from: startTeleporterNode, to: endTeleporterNode, cost: 1))
            endTeleporterNode.edges.insert(AStarEdge(from: endTeleporterNode, to: startTeleporterNode, cost: 1))
        }
                
        let startNode = nodes.first(where: {$0.position == self.startPosition})!
        let endNode = nodes.first(where: {$0.position == self.endPosition})!
        
        aStar.computeShortestPaths(startNode: startNode)
        self.setSolution(challenge: 0, text: "\(endNode.g)")
    }
    
    func solveSecond() {
        
    }
}
