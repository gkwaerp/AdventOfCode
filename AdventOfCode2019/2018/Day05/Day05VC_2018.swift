//
//  Day05VC_2018.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 04/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

fileprivate extension String {
    func isSameCharacterOppositeCase(otherChar: String) -> Bool {
        return (self.caseInsensitiveCompare(otherChar) == .orderedSame) && (otherChar != self)
    }
}

class Day05VC_2018: AoCVC, AdventDay, InputLoadable {
    private var inputString = [String]() // Array to allow for subscript etc.
    private var initialInput = [String]()

    private func reset() {
        self.inputString = initialInput
    }

    private func performReactions() {
        var somethingRemoved = true
        
        while somethingRemoved {
            somethingRemoved = false
            var index = 0
            while index < self.inputString.count - 1 {
                let a = self.inputString[index]
                let b = self.inputString[index + 1]
                if a.isSameCharacterOppositeCase(otherChar: b) {
                    self.inputString.remove(at: index + 1)
                    self.inputString.remove(at: index)
                    somethingRemoved = true
                } else {
                    index += 1
                }
            }
        }
    }
    
    func loadInput() {
        self.reset()
        self.initialInput = "Day05Input_2018".loadAsTextStringArray().first!.toStringArray()
    }
    
    func solveFirst() {
        self.reset()
        self.performReactions()
        self.setSolution(challenge: 0, text: "\(self.inputString.count)")
    }
    
    func solveSecond() {
        self.reset()
        self.performReactions()
        self.initialInput = self.inputString
        var bestSolutionFound = self.inputString.count
        for char in "qwertyuiopasdfghjklzxcvbnm".toStringArray() {
            self.reset()
            self.inputString = self.inputString.filter({$0 != char.uppercased() && $0 != char.lowercased()})
            self.performReactions()
            if self.inputString.count < bestSolutionFound {
                bestSolutionFound = inputString.count
            }
        }
        self.setSolution(challenge: 1, text: "\(bestSolutionFound)")
    }
}
