//
//  IntAStar.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 15/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

class AStarNode: Node, Hashable, Equatable {
    static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
        return lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.position)
    }
    
    var position: IntPoint
    var parent: Node?
    var children: [Node] = []
    var f: Int {
        return self.g + self.h
    }
    var g: Int!
    var h: Int!
    
    init(position: IntPoint) {
        self.position = position
        self.parent = nil
    }
}

class IntAStar {
    var open = Set<AStarNode>()
    var closed = Set<AStarNode>()
    
    // Traversal map: Position --> Walkable.
    func computeShortestPaths(start: IntPoint, end: IntPoint, traversalMap: [IntPoint: Bool]) {
        let startNode = AStarNode(position: start)
        startNode.g = 0
        startNode.h = 0
        
        self.open.insert(startNode)
        
        while !self.open.isEmpty
        {
            let current = self.open.min(by: {$0.f < $1.f})!
            self.open.remove(current)
            self.closed.insert(current)
            
            for direction in Direction.allCases {
                let potentialPos = current.position + direction.movementVector
                let wrapped = AStarNode(position: potentialPos)
                
                guard traversalMap[potentialPos] != nil else { fatalError() }
                guard traversalMap[potentialPos] == true else { continue }
                guard !self.closed.contains(wrapped) else { continue }
                wrapped.g = current.g + 1
                wrapped.h = potentialPos.manhattanDistance(to: end)
                wrapped.parent = current
                
                if let existingNode = self.open.first(where: {$0.position == potentialPos}) {
                    if wrapped.g < existingNode.g {
                        existingNode.g = wrapped.g
                        existingNode.parent = current
                    }
                } else {
                    self.open.insert(wrapped)
                }
            }
        }
    }
}
