//
//  IntMachine.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation

class IntMachine {
    struct Parameter {
        enum Mode: Int {
            case position = 0
            case immediate = 1
            case relative = 2

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

        let parameterMode: Parameter.Mode
        let value: Int

        static func from(memory: Memory, instructionPointer: Int, parameterOffset: Int) -> Parameter {
            let parameterModes = Parameter.Mode.getModes(for: memory.readValueDirect(index: instructionPointer))
            let currentParameterMode: Parameter.Mode
            let stateIndex = instructionPointer + parameterOffset
            if parameterModes.count > parameterOffset - 1 {
                currentParameterMode = parameterModes[parameterOffset - 1]
            } else {
                currentParameterMode = .position
            }

            return Parameter(parameterMode: currentParameterMode, value: memory.readValueDirect(index: stateIndex))
        }
    }

    class Memory {
        var state = [Int: Int]()
        var relativeBase = 0

        func reset() {
            self.relativeBase = 0
        }

        func loadProgram(program: [Int]) {
            for (index, value) in program.enumerated() {
                self.state[index] = value
            }
        }

        func readValue(from parameter: Parameter) -> Int {
            let index: Int
            switch parameter.parameterMode {
            case .position, .relative:
                index = self.getAddress(for: parameter)
            case .immediate:
                return parameter.value
            }
            
            return self.state[index] ?? 0
        }

        func readValueDirect(index: Int) -> Int {
            return self.state[index]!
        }

        func writeValue(_ value: Int, to: Parameter) {
            let writeIndex = self.getAddress(for: to)
            self.writeValueDirect(value, to: writeIndex)
        }

        func writeValueDirect(_ value: Int, to writeIndex: Int) {
            self.state[writeIndex] = value
        }

        func getAddress(for parameter: Parameter) -> Int {
            switch parameter.parameterMode {
            case .position:
                return parameter.value
            case .immediate:
                fatalError()
            case .relative:
                return parameter.value + self.relativeBase
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
        case adjustRelativeBase = 9
        case halt = 99
    }
    
    private enum Instruction {
        case addition(paramA: Parameter, paramB: Parameter, storeIn: Parameter)
        case multiplication(paramA: Parameter, paramB: Parameter, storeIn: Parameter)
        case input(storeIn: Parameter)
        case output(param: Parameter)
        case jumpIfTrue(paramA: Parameter, paramB: Parameter)
        case jumpIfFalse(paramA: Parameter, paramB: Parameter)
        case lessThan(paramA: Parameter, paramB: Parameter, storeIn: Parameter)
        case equals(paramA: Parameter, paramB: Parameter, storeIn: Parameter)
        case adjustRelativeBase(param: Parameter)
        case halt

        static func from(memory: Memory, at instructionPointer: Int) -> Instruction {
            let opcode = Opcode(rawValue: (memory.readValueDirect(index: instructionPointer)) % 100)!
            switch opcode {
            case .addition:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                let storeInParam = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 3)
                return .addition(paramA: paramA, paramB: paramB, storeIn: storeInParam)
            case .multiplication:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                let storeInParam = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 3)
                return .multiplication(paramA: paramA, paramB: paramB, storeIn: storeInParam)
            case .input:
                let storeInParam = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                return .input(storeIn: storeInParam)
            case .output:
                let param = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                return .output(param: param)
            case .jumpIfTrue:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                return .jumpIfTrue(paramA: paramA, paramB: paramB)
            case .jumpIfFalse:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                return .jumpIfFalse(paramA: paramA, paramB: paramB)
            case .lessThan:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                let storeInParam = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 3)
                return .lessThan(paramA: paramA, paramB: paramB, storeIn: storeInParam)
            case .equals:
                let paramA = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                let paramB = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 2)
                let storeInParam = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 3)
                return .equals(paramA: paramA, paramB: paramB, storeIn: storeInParam)
            case .adjustRelativeBase:
                let param = Parameter.from(memory: memory, instructionPointer: instructionPointer, parameterOffset: 1)
                return .adjustRelativeBase(param: param)
            case .halt:
                return .halt
            }
        }
    }

    enum ProgramStatus {
        case running(updateInstructionPointer: Bool)
        case waitingForInput
        case exitedSuccessfully(memoryAtZeroIndex: Int)
        case error
    }

    var inputs = [Int]()
    private var initialProgram = [Int]()
    private var workingMemory = Memory()
    private var instructionPointer = 0

    init() { }

    init(memory: [Int], noun: Int? = nil, verb: Int? = nil) {
        self.loadNewProgram(memory: memory, noun: noun, verb: verb)
    }

    func loadNewProgram(memory: [Int], noun: Int? = nil, verb: Int? = nil) {
        self.initialProgram = memory
        self.reset(noun: noun, verb: verb)
    }

    func reset(noun: Int? = nil, verb: Int? = nil) {
        self.workingMemory.loadProgram(program: self.initialProgram)
        self.workingMemory.reset()
        self.instructionPointer = 0

        if let noun = noun {
            self.workingMemory.state[1] = noun
        }
        if let verb = verb {
            self.workingMemory.state[2] = verb
        }
    }

    func setMemoryDirect(memoryAddress: Int, value: Int) {
        self.workingMemory.writeValueDirect(value, to: memoryAddress)
    }

    private func updateInstructionPointer(from instruction: Instruction) {
        switch instruction {
        case .addition: self.instructionPointer += 4
        case .multiplication: self.instructionPointer += 4
        case .input: self.instructionPointer += 2
        case .output: self.instructionPointer += 2
        case .jumpIfTrue: self.instructionPointer += 3
        case .jumpIfFalse: self.instructionPointer += 3
        case .lessThan: self.instructionPointer += 4
        case .equals: self.instructionPointer += 4
        case .adjustRelativeBase: self.instructionPointer += 2
        case .halt: self.instructionPointer += 1
        }
    }
    
    @discardableResult
    func run(outputHandler: IntBlock?) -> ProgramStatus {
        var programStatus: ProgramStatus = .running(updateInstructionPointer: false)
        while (true) {
            let instruction = Instruction.from(memory: self.workingMemory, at: self.instructionPointer)
            programStatus = self.execute(instruction: instruction, outputHandler: outputHandler)
            
            switch programStatus {
            case .running(let updateInstructionPointer):
                if updateInstructionPointer {
                    self.updateInstructionPointer(from: instruction)
                }
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
            let valueA = self.workingMemory.readValue(from: paramA)
            let valueB = self.workingMemory.readValue(from: paramB)
            self.workingMemory.writeValue(valueA + valueB, to: storeIn)
        case .multiplication(let paramA, let paramB, let storeIn):
            let valueA = self.workingMemory.readValue(from: paramA)
            let valueB = self.workingMemory.readValue(from: paramB)
            self.workingMemory.writeValue(valueA * valueB, to: storeIn)
        case .input(let storeIn):
            if let input = self.getInput() {
                self.workingMemory.writeValue(input, to: storeIn)
            } else {
                return .waitingForInput
            }
        case .output(let param):
            let value = self.workingMemory.readValue(from: param)
            outputHandler?(value)
        case .jumpIfTrue(let paramA, let paramB):
            let valueA = self.workingMemory.readValue(from: paramA)
            if valueA != 0 {
                self.instructionPointer = self.workingMemory.readValue(from: paramB)
                return .running(updateInstructionPointer: false)
            }
        case .jumpIfFalse(let paramA, let paramB):
            let valueA = self.workingMemory.readValue(from: paramA)
            if valueA == 0 {
                self.instructionPointer = self.workingMemory.readValue(from: paramB)
                return .running(updateInstructionPointer: false)
            }
        case .lessThan(let paramA, let paramB, let storeIn):
            let valueA = self.workingMemory.readValue(from: paramA)
            let valueB = self.workingMemory.readValue(from: paramB)
            let valueToStore = valueA < valueB ? 1 : 0
            self.workingMemory.writeValue(valueToStore, to: storeIn)
        case .equals(let paramA, let paramB, let storeIn):
            let valueA = self.workingMemory.readValue(from: paramA)
            let valueB = self.workingMemory.readValue(from: paramB)
            let valueToStore = valueA == valueB ? 1 : 0
            self.workingMemory.writeValue(valueToStore, to: storeIn)
        case .adjustRelativeBase(let param):
            let value = self.workingMemory.readValue(from: param)
            self.workingMemory.relativeBase += value
        case .halt:
            return .exitedSuccessfully(memoryAtZeroIndex: self.workingMemory.readValueDirect(index: 0))
        }

        return .running(updateInstructionPointer: true)
    }
}
