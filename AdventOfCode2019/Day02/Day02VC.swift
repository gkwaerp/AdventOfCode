//
//  Day02VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day02VC: AoCVC, AdventDay {
    class OpcodeMachine {
        enum Opcode {
            case addition(indexA: Int, indexB: Int, resultingIndex: Int)
            case multiplication(indexA: Int, indexB: Int, resultingIndex: Int)
            case halt

            static func from(ints: [Int], at offset: Int) -> Opcode {
                switch ints[offset] {
                case 1: return .addition(indexA: ints[offset + 1], indexB: ints[offset + 2], resultingIndex: ints[offset + 3])
                case 2: return .multiplication(indexA: ints[offset + 1], indexB: ints[offset + 2], resultingIndex: ints[offset + 3])
                case 99: return .halt
                default: fatalError()
                }
            }
        }

        private var initialMemory = [Int]()
        private var workingMemory = [Int]()
        private var instructionPointer = 0

        init(memory: [Int], noun: Int?, verb: Int?) {
            self.loadNewProgram(memory: memory, noun: noun, verb: verb)
        }

        func loadNewProgram(memory: [Int], noun: Int?, verb: Int?) {
            self.initialMemory = memory
            self.reset(noun: noun, verb: verb)
        }

        func reset(noun: Int?, verb: Int?) {
            self.workingMemory = self.initialMemory
            self.instructionPointer = 0

            if let noun = noun {
                guard self.workingMemory.count > 1 else { fatalError() }
                self.workingMemory[1] = noun
            }
            if let verb = verb {
                guard self.workingMemory.count > 2 else { fatalError() }
                self.workingMemory[2] = verb
            }
        }

        private func incrementInstructionPointer(from opcode: Opcode) {
            switch opcode {
            case .addition: self.instructionPointer += 4
            case .multiplication: self.instructionPointer += 4
            case .halt: self.instructionPointer += 1
            }
        }

        func runProgram() -> Int {
            var finished = false
            while !finished {
                let opcode = Opcode.from(ints: self.workingMemory, at: self.instructionPointer)
                finished = self.execute(opcode: opcode)
                self.incrementInstructionPointer(from: opcode)
            }
            return self.workingMemory[0]
        }

        private func execute(opcode: Opcode) -> Bool {
            switch opcode {
                case .addition(let indexA, let indexB, let resultingIndex):
                    self.workingMemory[resultingIndex] = self.workingMemory[indexA] + self.workingMemory[indexB]
                case .multiplication(let indexA, let indexB, let resultingIndex):
                    self.workingMemory[resultingIndex] = self.workingMemory[indexA] * self.workingMemory[indexB]
                case .halt:
                    return true
            }
            return false
        }
    }

    private var machine: OpcodeMachine!

    func loadInput() {
        let line = FileLoader.loadText(fileName: "Day02Input").first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.machine = OpcodeMachine(memory: ints, noun: nil, verb: nil)
    }

    func solveFirst() {
        self.machine.reset(noun: 12, verb: 2)
        let result = self.machine.runProgram()
        self.setSolution1("\(result)")
    }

    func solveSecond() {
        for noun in 0...99 {
            for verb in 0...99 {
                self.machine.reset(noun: noun, verb: verb)
                let result = self.machine.runProgram()
                if result == 19690720 {
                    self.setSolution2("\(noun * 100 + verb)")
                    return
                }
            }
        }
    }
}
