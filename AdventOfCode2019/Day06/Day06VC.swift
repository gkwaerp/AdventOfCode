//
//  Day06VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 05/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day06VC: AoCVC, AdventDay, InputLoadable {
    class StarNode: Node, Equatable, Hashable {
        let id: String
        let orbitsId: String?
        var children = [Node]()
        var parent: Node? = nil
        
        init(id: String, orbitsID: String?) {
            self.id = id
            self.orbitsId = orbitsID
        }
        
        static func from(string: String) -> StarNode {
            let split = string.split(separator: ")")
            let orbitsID = String(split[0])
            let id = String(split[1])
            return StarNode(id: id, orbitsID: orbitsID)
        }
        
        static func == (lhs: StarNode, rhs: StarNode) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.id)
        }
    }
    
    struct StarMap {
        func populate(from orbits: [StarNode]) {
            for orbit in orbits {
                if let orbitingAroundNode = orbits.first(where: {$0.id == orbit.orbitsId}) {
                    orbit.parent = orbitingAroundNode
                    orbitingAroundNode.children.append(orbit)
                }
            }
        }
        
        func calcChecksum(orbits: [StarNode]) -> Int {
            return orbits.map({$0.allParents.count}).reduce(0, +)
        }
        
        func calcMinimum(nodes: [StarNode]) -> Int {
            let you = nodes.first(where: {$0.id == "YOU"})!
            let santa = nodes.first(where: {$0.id == "SAN"})!
            
            let youParents = Set<StarNode>(you.allParents as! [StarNode])
            let santaParents = Set<StarNode>(santa.allParents as! [StarNode])
            return youParents.symmetricDifference(santaParents).count
        }
    }

    private var orbits = [StarNode]()
    private var starMap = StarMap()
    func loadInput() {
        let lines = "Day06Input".loadAsTextStringArray()
        self.orbits = lines.map({StarNode.from(string: $0)})
        self.orbits.append(StarNode(id: "COM", orbitsID: nil))
        self.starMap.populate(from: self.orbits)
    }
    
    func solveFirst() {
        let result = self.starMap.calcChecksum(orbits: self.orbits)
        self.setSolution(challenge: 0, text: "\(result)")
    }
    
    func solveSecond() {
        let result = self.starMap.calcMinimum(nodes: self.orbits)
        self.setSolution(challenge: 1, text: "\(result)")
    }
}
