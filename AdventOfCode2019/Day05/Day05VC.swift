//
//  Day05VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 05/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day05VC: AoCVC, AdventDay, InputLoadable {
    private var machine = IntMachine()

    func loadInput() {
        let line = "Day05Input".loadAsTextStringArray().first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.machine.loadNewProgram(memory: ints)
    }

    func solveFirst() {
        var outputs = [Int]()
        self.machine.inputs = [1]
        self.machine.run(outputHandler: { (outputValue) in
            outputs.append(outputValue)
            print(outputValue)
        })
        self.setSolution(challenge: 0, text: "\(outputs.last!)")
    }

    func solveSecond() {
        self.machine.reset()
        self.machine.inputs = [5]
        var outputs = [Int]()
        self.machine.run(outputHandler: { (outputValue) in
            outputs.append(outputValue)
        })
        self.setSolution(challenge: 1, text: "\(outputs.first!)")
    }
}
