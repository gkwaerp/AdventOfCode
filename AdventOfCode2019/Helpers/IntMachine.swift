//
//  IntMachine.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

class IntMachine {
    private struct Parameter {
        enum Mode: Int {
            case position = 0
            case immediate = 1

            static func getModes(for int: Int) -> [Parameter.Mode] {
                var parameterModes = [Parameter.Mode]()
                var parameterModeInput = int / 100
                while (parameterModeInput > 0) {
                    parameterModes.append(Parameter.Mode(rawValue: parameterModeInput % 10)!)
                    parameterModeInput /= 10
                }
                return parameterModes
            }
        }
        private let parameterMode: Parameter.Mode
        private let rawValue: Int

        static func from(memory: [Int], instructionPointer: Int, parameterOffset: Int) -> Parameter {
            let parameterModes = Parameter.Mode.getModes(for: memory[instructionPointer])
            let currentParameterMode: Parameter.Mode
            let rawValue = instructionPointer + parameterOffset
            if parameterModes.count > parameterOffset - 1 {
                currentParameterMode = parameterModes[parameterOffset - 1]
            } else {
                currentParameterMode = .position
            }

            return Parameter(parameterMode: currentParameterMode, rawValue: rawValue)
        }

        func value(for memory: [Int]) -> Int {
            switch self.parameterMode {
            case .immediate:
                return memory[self.rawValue]
            case .position:
                return memory[memory[self.rawValue]]
            }
        }
    }
    
    private enum Opcode: Int {
        case addition = 1
        case multiplication = 2
        case input = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case halt = 99
    }
    
    private enum Instruction {
        case addition(paramA: Parameter, paramB: Parameter, storeIn: Int)
        case multiplication(paramA: Parameter, paramB: Parameter, storeIn: Int)
        case input(storeIn: Int)
        case output(param: Parameter)
        case jumpIfTrue(instructionPointerValue: Parameter?)
        case jumpIfFalse(instructionPointerValue: Parameter?)
        case lessThan(value: Int, storeIn: Int)
        case equals(value: Int, storeIn: Int)
        case halt

        static func from(memory: [Int], at instructionPointer: Int) -> Instruction {
            let opcode = Opcode(rawValue: memory[instructionPointer] % 100)!
            switch opcode {
            case .addition:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                return .addition(paramA: paramA, paramB: paramB, storeIn: memory[instructionPointer + 3])
            case .multiplication:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                return .multiplication(paramA: paramA, paramB: paramB, storeIn: memory[instructionPointer + 3])
            case .input:
                return .input(storeIn: memory[instructionPointer + 1])
            case .output:
                let param = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                return .output(param: param)
            case .jumpIfTrue:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                return .jumpIfTrue(instructionPointerValue: paramA.value(for: memory) == 0 ? nil : paramB)
            case .jumpIfFalse:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                return .jumpIfFalse(instructionPointerValue: paramA.value(for: memory) != 0 ? nil : paramB)
            case .lessThan:
                let valueA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1).value(for: memory)
                let valueB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2).value(for: memory)
                let valueToStore = valueA < valueB ? 1 : 0
                return .lessThan(value: valueToStore, storeIn: memory[instructionPointer + 3])
            case .equals:
                let valueA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1).value(for: memory)
                let valueB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2).value(for: memory)
                let valueToStore = valueA == valueB ? 1 : 0
                return .equals(value: valueToStore, storeIn: memory[instructionPointer + 3])
            case .halt:
                return .halt
            }
        }
    }

    enum ProgramStatus {
        case running
        case waitingForInput
        case exitedSuccessfully(memoryAtZeroIndex: Int)
        case error
    }

    var inputs = [Int]()
    private var initialMemory = [Int]()
    private var workingMemory = [Int]()
    private var instructionPointer = 0

    init() { }

    init(memory: [Int], noun: Int?, verb: Int?) {
        self.loadNewProgram(memory: memory, noun: noun, verb: verb)
    }

    func loadNewProgram(memory: [Int], noun: Int? = nil, verb: Int? = nil) {
        self.initialMemory = memory
        self.reset(noun: noun, verb: verb)
    }

    func reset(noun: Int? = nil, verb: Int? = nil) {
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

    private func updateInstructionPointer(from instruction: Instruction) {
        switch instruction {
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
    
    @discardableResult
    func run(outputHandler: IntBlock?) -> ProgramStatus {
        var programStatus: ProgramStatus = .running
        while (true) {
            let instruction = Instruction.from(memory: self.workingMemory, at: instructionPointer)
            programStatus = self.execute(instruction: instruction, outputHandler: outputHandler)
            
            switch programStatus {
            case .running:
                self.updateInstructionPointer(from: instruction)
            case .error, .waitingForInput, .exitedSuccessfully:
                return programStatus
            }
        }
    }

    private func getInput() -> Int? {
        guard !self.inputs.isEmpty else { return nil }
        let input = self.inputs.first!
        self.inputs.remove(at: 0)
        return input
    }

    private func execute(instruction: Instruction, outputHandler: IntBlock?) -> ProgramStatus {
        switch instruction {
        case .addition(let paramA, let paramB, let storeIn):
            self.workingMemory[storeIn] = paramA.value(for: self.workingMemory) + paramB.value(for: self.workingMemory)
        case .multiplication(let paramA, let paramB, let storeIn):
            self.workingMemory[storeIn] = paramA.value(for: self.workingMemory) * paramB.value(for: self.workingMemory)
        case .input(let storeInIndex):
            if let input = self.getInput() {
                self.workingMemory[storeInIndex] = input
            } else {
                return .waitingForInput
            }
        case .output(let param):
            outputHandler?(param.value(for: self.workingMemory))
        case .jumpIfTrue(let instructionPointerValue):
            if let instructionPointerValue = instructionPointerValue {
                self.instructionPointer = instructionPointerValue.value(for: self.workingMemory)
            }
        case .jumpIfFalse(let instructionPointerValue):
            if let instructionPointerValue = instructionPointerValue {
                self.instructionPointer = instructionPointerValue.value(for: self.workingMemory)
            }
        case .lessThan(let value, let storeIn):
            self.workingMemory[storeIn] = value
        case .equals(let value, let storeIn):
            self.workingMemory[storeIn] = value
        case .halt:
            return .exitedSuccessfully(memoryAtZeroIndex: self.workingMemory[0])
        }

        return .running
    }
}
