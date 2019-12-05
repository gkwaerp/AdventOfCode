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
//        let line = "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31, 1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104, 999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
//        let line = "3,9,8,9,10,9,4,9,99,-1,8"
//        let line = "3,9,7,9,10,9,4,9,99,-1,8"
//        let line = "3,3,1108,-1,8,3,4,3,99"
//        let line = "3,3,1107,-1,8,3,4,3,99"
//        let line = "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
//        let line = "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.machine.loadNewProgram(memory: ints, noun: nil, verb: nil)
    }

    func solveFirst() {
        let result = self.machine.runProgram()
        self.setSolution1("\(result)")
    }

    func solveSecond() {
    }
}
