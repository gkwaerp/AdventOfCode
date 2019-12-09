//
//  Day09VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 09/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day09VC: AoCVC, AdventDay {
    let machine = IntMachine()
    func loadInput() {
        let line = FileLoader.loadText(fileName: "Day09Input").first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.machine.loadNewProgram(memory: ints)
    }
    
    func solveFirst() {
        self.machine.reset()
        self.machine.inputs = [1]
        self.machine.run { (outputValue) in
            self.setSolution1("\(outputValue)")
        }
    }
    
    func solveSecond() {
        self.machine.reset()
        self.machine.inputs = [2]
        self.machine.run { (outputValue) in
            self.setSolution2("\(outputValue)")
        }
    }
}
