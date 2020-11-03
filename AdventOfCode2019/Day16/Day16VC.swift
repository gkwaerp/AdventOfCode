//
//  Day16VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 16/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day16VC: AoCVC, AdventDay, InputLoadable {
    var rawInput = [Int]()
    var messageOffset: Int!
    
    func loadInput() {
        let input = "Day16Input".loadAsTextStringArray().first!
        self.messageOffset = Int(input.prefix(7))!
        self.rawInput = input.map({Int("\($0)")!})
    }
    
    func solveFirst() {
        let basePattern = [0, 1, 0, -1]
        let patternCount = basePattern.count
        
        let inputCount = rawInput.count
        var currentInput = rawInput
        var nextInput = currentInput
        
        let numPhases = 100
        for _ in 0..<numPhases {
            for outerIndex in 0..<inputCount {
                var currentTotal = 0
                var innerIndex = outerIndex
                while innerIndex < inputCount {
                    let patternIndex = ((innerIndex + 1) / (outerIndex + 1)) % patternCount
                    let patternValue = basePattern[patternIndex]
                    currentTotal += patternValue * currentInput[innerIndex]
                    if patternValue == 0 {
                        innerIndex += outerIndex + 1
                    } else {
                        innerIndex += 1
                    }
                }
                nextInput[outerIndex] = (abs(currentTotal) % 10)
            }
            
            currentInput = nextInput
        }
        let messageOffset = 0
        var finalString = ""
        for i in 0..<8 {
            finalString.append("\(currentInput[i + messageOffset])")
        }
        self.setSolution(challenge: 0, text: "\(finalString)")
    }
    
    func solveSecond() {
        var actualInput = [Int]()
        for _ in 0..<10000 {
            actualInput.append(contentsOf: self.rawInput)
        }
        let inputCount = actualInput.count
        var currentInput = actualInput
        var nextInput = actualInput
        
        let numPhases = 100
        for _ in 0..<numPhases {
            var currentIndex = inputCount - 2
            nextInput[currentIndex + 1] = currentInput[currentIndex + 1]
            while currentIndex >= self.messageOffset {
                nextInput[currentIndex] = (nextInput[currentIndex + 1] + currentInput[currentIndex]) % 10
                currentIndex -= 1
            }
            currentInput = nextInput
        }
        
        var finalString = ""
        for i in 0..<8 {
            finalString.append("\(currentInput[i + messageOffset])")
        }
        self.setSolution(challenge: 1, text: "\(finalString)")
    }
}
