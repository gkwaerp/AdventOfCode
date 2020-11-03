//
//  Day24VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 25/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day24VC: AoCVC, AdventDay, InputLoadable {
    var bugArea = [Bool]()
    var height = 0
    var width = 0
    var size = 0
    
    func loadInput() {
        let lines = "Day24Input".loadAsTextStringArray()
        self.height = lines.count
        self.width = lines.first!.count
        self.size = self.height * self.width
        
        for line in lines {
            for char in line {
                self.bugArea.append(char == "#")
            }
        }
    }
    
    func getIndex(x: Int, y: Int) -> Int {
        return y * self.width + x
    }
    
    func getNumBugsNearby(index: Int) -> Int {
        let y = index / self.width
        let x = index % self.width
        
        var nearbyBugCount = 0
        if y > 0 && self.bugArea[self.getIndex(x: x, y: y - 1)] {
            nearbyBugCount += 1
        }
        
        if (y + 1) < self.height && self.bugArea[self.getIndex(x: x, y: y + 1)] {
            nearbyBugCount += 1
        }
        
        if x > 0 && self.bugArea[self.getIndex(x: x - 1, y: y)] {
            nearbyBugCount += 1
        }
        
        if (x + 1) < self.width && self.bugArea[self.getIndex(x: x + 1, y: y)] {
            nearbyBugCount += 1
        }
        
        return nearbyBugCount
    }
    
    func tick() {
        var newBugArea = bugArea
        for i in 0..<self.size {
            let isCurrentBug = self.bugArea[i]
            let numBugsNearby = self.getNumBugsNearby(index: i)
            if isCurrentBug {
                newBugArea[i] = numBugsNearby == 1
            } else {
                newBugArea[i] = (numBugsNearby == 1) || (numBugsNearby == 2)
            }
            
        }
        
        self.bugArea = newBugArea
    }
    
    func printBugArea() {
        var finalString = ""
        var index = 0
        for _ in 0..<self.height {
            for _ in 0..<self.width {
                finalString.append(self.bugArea[index] ? "#" : ".")
                index += 1
            }
            finalString.append("\n")
        }
        
        print(finalString)
    }
    
    func getBioDiversity() -> Int {
        var total = 0
        var val = 1
        for i in 0..<self.size {
            total += self.bugArea[i] ? val : 0
            val *= 2
        }
        return total
    }
    
    func solveFirst() {
        var seenBioDiversities = Set<Int>()
        while true {
            let bioDiversity = self.getBioDiversity()
            if !seenBioDiversities.insert(bioDiversity).inserted {
                self.setSolution(challenge: 0, text: "\(bioDiversity)")
                break
            }
            self.tick()
        }
    }
    
    func solveSecond() {
        
    }
}
