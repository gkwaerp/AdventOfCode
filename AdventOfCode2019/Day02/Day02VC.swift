//
//  Day02VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day02VC: AoCVC, AdventDay {
    private var machine = IntMachine()

    func loadInput() {
        let line = FileLoader.loadText(fileName: "Day02Input").first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.machine.loadNewProgram(memory: ints)
    }

    func solveFirst() {
        self.machine.reset(noun: 12, verb: 2)
        let result = self.machine.run(outputHandler: nil)
        switch result {
        case .exitedSuccessfully(let memoryAtZeroIndex):
            self.setSolution1("\(memoryAtZeroIndex)")
        default: break
        }
    }

    func solveSecond() {
        for noun in 0...99 {
            for verb in 0...99 {
                self.machine.reset(noun: noun, verb: verb)
                let result = self.machine.run(outputHandler: nil)
                switch result {
                case .exitedSuccessfully(let memoryAtZeroIndex):
                    if memoryAtZeroIndex == 19690720 {
                        self.setSolution2("\(noun * 100 + verb)")
                        return
                    }
                default: break
                }
            }
        }
    }
}
