//
//  Day06VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 05/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day06VC: AoCVC, AdventDay {
    class Node {
        let id: String
        let orbitsId: String?
        var children = [Node]()
        weak var parent: Node?

        init(id: String, orbitsID: String?) {
            self.id = id
            self.orbitsId = orbitsID
        }

        static func from(string: String) -> Node {
            let split = string.split(separator: ")")
            let orbitsID = String(split[0])
            let id = String(split[1])
            return Node(id: id, orbitsID: orbitsID)
        }
    }

    struct StarMap {
        func populate(from orbits: [Node]) {
            for orbit in orbits {
                if let orbitingAroundNode = orbits.first(where: {$0.id == orbit.orbitsId}) {
                    orbit.parent = orbitingAroundNode
                    orbitingAroundNode.children.append(orbit)
                }
            }
        }

        func calcChecksum(orbits: [Node]) -> Int {
            var count = 0
            for orbit in orbits {
                var currentNode = orbit
                while let parent = currentNode.parent {
                    count += 1
                    currentNode = parent
                }
            }
            return count
        }

        func calcMinimum(nodes: [Node]) -> Int {
            let you = nodes.first(where: {$0.id == "YOU"})!
            let santa = nodes.first(where: {$0.id == "SAN"})!

            var youParents = [Node]()
            var currentNode = you
            while let parent = currentNode.parent {
                youParents.append(parent)
                currentNode = parent
                
            }
            
            var santaParents = [Node]()
            currentNode = santa
            while let parent = currentNode.parent {
                santaParents.append(parent)
                currentNode = parent
                
            }
            
            var commonParent: Node!
            var countToParent = 0
            if youParents.count < santaParents.count {
                for i in 0..<santaParents.count {
                    if youParents.first(where: {$0.id == santaParents[i].id}) != nil {
                        commonParent = santaParents[i]
                        countToParent = i
                        break
                    }
                }
            } else {
                for i in 0..<youParents.count {
                    if santaParents.first(where: {$0.id == youParents[i].id}) != nil {
                        commonParent = youParents[i]
                        countToParent = i
                        break
                    }
                }
                
            }

            for santaParent in santaParents {
                if santaParent.id == commonParent.id {
                    return countToParent
                }
                countToParent += 1
                
            }
            
            return -1
        }
    }
    private var orbits = [Node]()
    private var starMap = StarMap()
    func loadInput() {
        let lines = FileLoader.loadText(fileName: "Day06Input")
        self.orbits = lines.map({Node.from(string: $0)})
        self.orbits.append(Node(id: "COM", orbitsID: nil))
        self.starMap.populate(from: self.orbits)
        
    }
    
    func solveFirst() {
        let result = self.starMap.calcChecksum(orbits: self.orbits)
        self.setSolution1("\(result)")
    }
    
    func solveSecond() {
        let result = self.starMap.calcMinimum(nodes: self.orbits)
        self.setSolution2("\(result)")
    }
}
