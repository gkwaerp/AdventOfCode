//
//  Day19VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 19/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day19VC: AoCVC, AdventDay, InputLoadable {
    private let machine = IntMachine()
    
    func loadInput() {
        let lines = "Day19Input".loadAsTextStringArray().first!.components(separatedBy: ",")
        let program = lines.map({Int("\($0)")!})
        self.machine.loadNewProgram(memory: program)
    }
    
    func solveFirst() {
        var numAffected = 0
        for y in 0..<50 {
            for x in 0..<50 {
                self.machine.reset()
                self.machine.inputs.append(x)
                self.machine.inputs.append(y)
                self.machine.run { (output) in
                    numAffected += output
                }
            }
        }
        self.setSolution(challenge: 0, text: "\(numAffected)")
    }
    
    // Should be possible to math this better by checking tractor beam slope, etc.
    func solveSecond() {
        let shipSize = 100
        var y = 1000 // Based on output, rough underestimate of first viable position
        yLoop: while true {
            var x = y
            var somethingSeen = false
            xLoop: while true {
                if self.check(x: x, y: y) {
                    somethingSeen = true
                } else if somethingSeen {
                    continue yLoop
                }
                
                if somethingSeen {
                    let top = y - (shipSize - 1)
                    let right = x + (shipSize - 1)
                    let otherCorners = [IntPoint(x: x, y: top),
                                        IntPoint(x: right, y: y),
                                        IntPoint(x: right, y: top)]
                    
                    if otherCorners.allSatisfy({self.check(x: $0.x, y: $0.y)}) {
                        self.setSolution(challenge: 1, text: "\(x * 10000 + top)")
                        return
                    } else {
                        break xLoop
                    }
                }
                x += 1
            }
            y += 1
        }
    }
    
    private func check(x: Int, y: Int) -> Bool {
        var output = 0
        self.machine.reset()
        self.machine.inputs.append(x)
        self.machine.inputs.append(y)
        self.machine.run { (outputValue) in
            output = outputValue
        }
        
        return output == 1
    }
}
