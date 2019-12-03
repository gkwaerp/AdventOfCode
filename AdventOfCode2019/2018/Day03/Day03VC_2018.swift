//
//  Day03VC_2018.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day03VC_2018: AoCVC, AdventDay {
    private struct Claim: Hashable {
        struct Position: Hashable {
            let x: Int
            let y: Int
        }
        let id: Int
        let position: Position
        let w: Int
        let h: Int

        init(string: String) {
            let split = string.split(separator: " ")
            self.id = Int(split[0].replacingOccurrences(of: "#", with: ""))!
            
            let xy = split[2].replacingOccurrences(of: ":", with: "").split(separator: ",")
            self.position = Position(x: Int(xy[0])!, y: Int(xy[1])!)

            let wh = split[3].split(separator: "x")
            self.w = Int(wh[0])!
            self.h = Int(wh[1])!
        }

        var positions: Set<Position> {
            var allPositions = Set<Position>()
            for height in 0..<self.h {
                for width in 0..<self.w {
                    allPositions.insert(Position(x: self.position.x + width, y: self.position.y + height))
                }
            }
            return allPositions
        }
    }

    private var claims = Set<Claim>()

    func loadInput() {
        self.claims = Set(FileLoader.loadText(fileName: "Day03Input_2018").map({Claim(string: $0)}))
    }

    func solveFirst() {
        var set = Set<Claim.Position>()
        var duplicated = Set<Claim.Position>()
        for claim in self.claims {
            for position in claim.positions {
                if set.contains(position) {
                    duplicated.insert(position)
                } else {
                    set.insert(position)
                }
            }
        }

        self.setSolution1("\(duplicated.count)")
    }

    func solveSecond() {
        var dictionary = [Claim.Position: Claim]()
        var nonOverlappingClaims = Set(self.claims)
        for claim in self.claims {
            for position in claim.positions {
                if let existingClaim = dictionary[position] {
                    nonOverlappingClaims.remove(existingClaim)
                    nonOverlappingClaims.remove(claim)
                } else {
                    dictionary[position] = claim
                }
            }
        }

        self.setSolution2("\(nonOverlappingClaims.first!.id)")
    }
}