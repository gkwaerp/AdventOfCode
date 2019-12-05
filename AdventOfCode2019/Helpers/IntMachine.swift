//
//  IntMachine.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

class IntMachine {
    enum ParameterMode: Int {
        case position = 0
        case immediate = 1
    }

    enum Opcode {
        case addition(valueA: Int, valueB: Int, resultingIndex: Int)
        case multiplication(valueA: Int, valueB: Int, resultingIndex: Int)
        case input(value: Int, storeIn: Int)
        case output(value: Int)
        case jumpIfTrue(instructionPointerValue: Int?)
        case jumpIfFalse(instructionPointerValue: Int?)
        case lessThan(value: Int, resultingIndex: Int)
        case equals(value: Int, resultingIndex: Int)
        case halt

        private static func getParamModes(for int: Int) -> [ParameterMode] {
            var parameterModes = [ParameterMode]()
            var parameterModeInput = int / 100
            while (parameterModeInput > 0) {
                parameterModes.append(ParameterMode(rawValue: parameterModeInput % 10)!)
                parameterModeInput /= 10
            }
            return parameterModes
        }

        private static func getValue(ints: [Int], offset: Int, parameterOffset: Int, parameterModes: [ParameterMode]) -> Int {
            let parameterType: ParameterMode
            if parameterModes.count > parameterOffset {
                parameterType = parameterModes[parameterOffset]
            } else {
                parameterType = .position
            }

            switch parameterType {
            case .immediate: return ints[offset + parameterOffset + 1]
            case .position: return ints[ints[offset + parameterOffset + 1]]
            }
        }

        static func from(ints: [Int], at offset: Int) -> Opcode {
            let parameterCode = ints[offset] % 100
            let parameterModes = getParamModes(for: ints[offset])
            switch parameterCode {
            case 1:
                let valueA = getValue(ints: ints, offset: offset, parameterOffset: 0, parameterModes: parameterModes)
                let valueB = getValue(ints: ints, offset: offset, parameterOffset: 1, parameterModes: parameterModes)
                return .addition(valueA: valueA, valueB: valueB, resultingIndex: ints[offset + 3])
            case 2:
                let valueA = getValue(ints: ints, offset: offset, parameterOffset: 0, parameterModes: parameterModes)
                let valueB = getValue(ints: ints, offset: offset, parameterOffset: 1, parameterModes: parameterModes)
                return .multiplication(valueA: valueA, valueB: valueB, resultingIndex: ints[offset + 3])
            case 3:
                return .input(value: 5, storeIn: ints[offset + 1])
            case 4:
                let valueA = getValue(ints: ints, offset: offset, parameterOffset: 0, parameterModes: parameterModes)
                return .output(value: valueA)
            case 5:
                let valueA = getValue(ints: ints, offset: offset, parameterOffset: 0, parameterModes: parameterModes)
                let valueB = getValue(ints: ints, offset: offset, parameterOffset: 1, parameterModes: parameterModes)
                return .jumpIfTrue(instructionPointerValue: valueA == 0 ? nil : valueB)
            case 6:
                let valueA = getValue(ints: ints, offset: offset, parameterOffset: 0, parameterModes: parameterModes)
                let valueB = getValue(ints: ints, offset: offset, parameterOffset: 1, parameterModes: parameterModes)
                return .jumpIfFalse(instructionPointerValue: valueA != 0 ? nil : valueB)
            case 7:
                let valueA = getValue(ints: ints, offset: offset, parameterOffset: 0, parameterModes: parameterModes)
                let valueB = getValue(ints: ints, offset: offset, parameterOffset: 1, parameterModes: parameterModes)
                let valueToStore = valueA < valueB ? 1 : 0
                return .lessThan(value: valueToStore, resultingIndex: ints[offset + 3])
            case 8:
                let valueA = getValue(ints: ints, offset: offset, parameterOffset: 0, parameterModes: parameterModes)
                let valueB = getValue(ints: ints, offset: offset, parameterOffset: 1, parameterModes: parameterModes)
                let valueToStore = valueA == valueB ? 1 : 0
                return .equals(value: valueToStore, resultingIndex: ints[offset + 3])
            case 99: return .halt
            default: fatalError()
            }
        }
    }

    private var initialMemory = [Int]()
    private var workingMemory = [Int]()
    private var instructionPointer = 0

    init() { }

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

    private func updateInstructionPointer(from opcode: Opcode) {
        switch opcode {
        case .addition: self.instructionPointer += 4
        case .multiplication: self.instructionPointer += 4
        case .input: self.instructionPointer += 2
        case .output: self.instructionPointer += 2
        case .jumpIfTrue(let instructionPointerValue): self.instructionPointer += (instructionPointerValue == nil) ? 3 : 0
        case .jumpIfFalse(let instructionPointerValue): self.instructionPointer += (instructionPointerValue == nil) ? 3 : 0
        case .lessThan: self.instructionPointer += 4
        case .equals: self.instructionPointer += 4
        case .halt: self.instructionPointer += 1
        }
    }

    func runProgram() -> Int {
        var finished = false
        while !finished {
            let opcode = Opcode.from(ints: self.workingMemory, at: self.instructionPointer)
            finished = self.execute(opcode: opcode)
            self.updateInstructionPointer(from: opcode)
        }
        return self.workingMemory[0]
    }

    private func execute(opcode: Opcode) -> Bool {
        switch opcode {
        case .addition(let valueA, let valueB, let resultingIndex):
            self.workingMemory[resultingIndex] = valueA + valueB
        case .multiplication(let valueA, let valueB, let resultingIndex):
            self.workingMemory[resultingIndex] = valueA * valueB
        case .input(let value, let storeInIndex):
            self.workingMemory[storeInIndex] = value
        case .output(let value):
            print(value)
        case .jumpIfTrue(let instructionPointerValue):
            self.instructionPointer = instructionPointerValue ?? self.instructionPointer
        case .jumpIfFalse(let instructionPointerValue):
            self.instructionPointer = instructionPointerValue ?? self.instructionPointer
        case .lessThan(let value, let resultingIndex):
            self.workingMemory[resultingIndex] = value
        case .equals(let value, let resultingIndex):
            self.workingMemory[resultingIndex] = value
        case .halt:
            return true
        }
        return false
    }
}
