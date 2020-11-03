//
//  Day07VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 07/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day07VC: AoCVC, AdventDay, InputLoadable {
    private var machines = [IntMachine]()
    
    func loadInput() {
        let line = "Day07Input".loadAsTextStringArray().first!
        let ints = line.components(separatedBy: ",").compactMap({Int($0)})
        for i in 0..<5 {
            self.machines.append(IntMachine())
            self.machines[i].loadNewProgram(memory: ints)
        }
    }
    
    private func permute(remainingNumbers: [String], currentNumbers: [String], allPermutations: inout [[String]]) {
        guard !remainingNumbers.isEmpty else {
            allPermutations.append(currentNumbers)
            return
        }
        
        for (index, number) in remainingNumbers.enumerated() {
            var newRemaining = remainingNumbers
            newRemaining.remove(at: index)
            self.permute(remainingNumbers: newRemaining, currentNumbers: currentNumbers + [number], allPermutations: &allPermutations)
        }
    }
    
    private func generatePhaseSettings(settings: [Int]) -> [[Int]] {
        let inputToPermute = settings.map({"\($0)"})
        var allPermutations = [[String]]()
        self.permute(remainingNumbers: inputToPermute, currentNumbers: [], allPermutations: &allPermutations)
        
        var phaseSettings = [[Int]]()
        for phaseSettingString in allPermutations {
            var phaseSetting = [Int]()
            for phaseSettingChar in phaseSettingString {
                phaseSetting.append(Int("\(phaseSettingChar)")!)
            }
            phaseSettings.append(phaseSetting)
        }
        
        return phaseSettings
    }
    
    func solveFirst() {
        var inputs = [Int]()
        var outputs = [Int]()
        let allPhaseSettings = self.generatePhaseSettings(settings: [0, 1, 2, 3, 4])
        var bestOutputSignal = 0
        for phaseSetting in allPhaseSettings {
            outputs = []
            for machineId in 0..<self.machines.count {
                let machine = self.machines[machineId]
                let machinePhaseSetting = phaseSetting[machineId]
                inputs = [machinePhaseSetting, outputs.last ?? 0]
                machine.reset(noun: nil, verb: nil)
                machine.inputs = inputs
                _ = machine.run { (outputValue) in
                    outputs.append(outputValue)
                }
            }
            bestOutputSignal = max(bestOutputSignal, outputs.last!)
        }
        
        self.setSolution(challenge: 0, text: "\(bestOutputSignal)")
    }
    
    func solveSecond() {
        var allInputs = [[Int]]()
        
        var bestOutputSignal = 0
        
        let allPhaseSettings = self.generatePhaseSettings(settings: [5, 6, 7, 8, 9])
        for phaseSetting in allPhaseSettings {
            allInputs = [[phaseSetting[0], 0],
                         [phaseSetting[1]],
                         [phaseSetting[2]],
                         [phaseSetting[3]],
                         [phaseSetting[4]]]

            for machineId in 0..<self.machines.count {
                let machine = self.machines[machineId]
                machine.reset()
                machine.inputs = allInputs[machineId]
            }

            var bestThisIteration = 0

            var isFinished = false
            while !isFinished {
                for machineId in 0..<self.machines.count {
                    let machine = self.machines[machineId]
                    let nextId = (machineId + 1) % self.machines.count
                    let programStatus = machine.run { (outputValue) in
                        print("Output from \(machineId): \(outputValue)")
                        self.machines[nextId].inputs.append(outputValue)

                        if machineId == self.machines.count - 1 {
                            bestThisIteration = max(bestThisIteration, outputValue)
                        }
                    }

                    switch programStatus {
                    case .exitedSuccessfully, .error:
                        isFinished = true
                    default: break
                    }
                }
            }
            bestOutputSignal = max(bestOutputSignal, bestThisIteration)
        }

        self.setSolution(challenge: 1, text: "\(bestOutputSignal)")
    }
}
