//
//  Day05VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 05/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day05VC: AoCVC, AdventDay {
    private var machine = IntMachine()

    func loadInput() {
        let line = FileLoader.loadText(fileName: "Day05Input").first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.machine.loadNewProgram(memory: ints, noun: nil, verb: nil)
    }

    func solveFirst() {
        var outputs = [Int]()
        self.machine.inputs = [1]
        self.machine.run(outputHandler: { (outputValue) in
            outputs.append(outputValue)
        })
        self.setSolution1("\(outputs.last!)")
    }

    func solveSecond() {
        self.machine.reset(noun: nil, verb: nil)
        self.machine.inputs = [5]
        var outputs = [Int]()
        self.machine.run(outputHandler: { (outputValue) in
            outputs.append(outputValue)
        })
        self.setSolution2("\(outputs[0])")
    }
}
