//
//  Day02VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day02VC: AoCVC {
    private enum Opcode {
        case addition(indexA: Int, indexB: Int, resultingIndex: Int)
        case multiplication(indexA: Int, indexB: Int, resultingIndex: Int)
        case halt

        static func from(ints: [Int]) -> Opcode {
            switch ints[0] {
            case 1:
                guard ints.count == 4 else { fatalError() }
                return .addition(indexA: ints[1], indexB: ints[2], resultingIndex: ints[3])
            case 2:
                guard ints.count == 4 else { fatalError() }
                return .multiplication(indexA: ints[1], indexB: ints[2], resultingIndex: ints[3])
            case 99:
                return .halt
            default: fatalError()
            }
        }
    }

    private var originalInput = [Int]()
    private var memory = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInput()
        self.solveFirst()
        self.solveSecond()
    }

    private func loadInput() {
        let line = FileLoader.loadText(fileName: "Day02Input").first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        self.originalInput = ints
    }

    private func resetMemory(noun: Int, verb: Int) {
        self.memory = originalInput
        self.memory[1] = noun
        self.memory[2] = verb
    }

    private func solveFirst() {
        self.resetMemory(noun: 12, verb: 2)

        var finished = false
        var commandList = self.memory
        while (!finished) {
            let opcodeInts = Array(commandList.prefix(4))
            commandList = Array(commandList.dropFirst(4))
            let opcode = Opcode.from(ints: opcodeInts)
            switch opcode {
            case .addition(let indexA, let indexB, let resultingIndex):
                self.memory[resultingIndex] = self.memory[indexA] + self.memory[indexB]
            case .multiplication(let indexA, let indexB, let resultingIndex):
                self.memory[resultingIndex] = self.memory[indexA] * self.memory[indexB]
            case .halt:
                finished = true
            }
        }

        self.setSolution1("\(self.memory[0])")
    }

    private func solveSecond() {
        for noun in 0...99 {
            for verb in 0...99 {
                self.resetMemory(noun: noun, verb: verb)

                var finished = false
                var commandList = self.memory
                while (!finished) {
                    let opcodeInts = Array(commandList.prefix(4))
                    commandList = Array(commandList.dropFirst(4))
                    let opcode = Opcode.from(ints: opcodeInts)
                    switch opcode {
                    case .addition(let indexA, let indexB, let resultingIndex):
                        self.memory[resultingIndex] = self.memory[indexA] + self.memory[indexB]
                    case .multiplication(let indexA, let indexB, let resultingIndex):
                        self.memory[resultingIndex] = self.memory[indexA] * self.memory[indexB]
                    case .halt:
                        finished = true
                    }
                }

                if self.memory[0] == 19690720 {
                    self.setSolution2("\(noun * 100 + verb)")
                    return
                }
            }
        }
    }
}
