//
//  Day14VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 14/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day14VC: AoCVC, AdventDay {
    private class ChemicalStorage {
        var chemicals = [String: Int]() // Chemicals --> quantity stored

        func resetOreQuantity(quantity: Int) {
            self.chemicals["ORE"] = quantity
        }

        func withdrawChemical(chemical: String, quantity: Int) -> Bool {
            if chemical == "ORE" && self.chemicals["ORE"] == nil {
                return true
            }
            
            guard let currentQuantity = self.chemicals[chemical] else { return false }
            guard currentQuantity >= quantity else { return false}
            self.chemicals[chemical]! -= quantity
            return true
        }
        
        func storeChemical(chemical: String, quantity: Int) {
            let currentQuantity = self.chemicals[chemical] ?? 0
            self.chemicals[chemical] = currentQuantity + quantity
        }

        func quantityOf(chemical: String) -> Int {
            return self.chemicals[chemical] ?? 0
        }
    }
    
    private struct ReactionRecipe {
        let input: [(chemical: String, quantity: Int)]
        let outputChemical: String
        let outputQuantity: Int

        static func from(string: String) -> ReactionRecipe {
            var reactionInputs = [(String, Int)]()
            
            let inputOutput = string.split(separator: "=")
            let inputList = inputOutput[0]
            let inputs = inputList.components(separatedBy: ",")
            
            for input in inputs {
                let quantityChemical = input.split(separator: " ")
                let quantity = Int(quantityChemical[0])!
                let chemical = String(quantityChemical[1])
                reactionInputs.append((chemical, quantity))
            }
            
            let output = inputOutput[1].replacingOccurrences(of: "> ", with: "")
            let outputQuantityChemical = output.split(separator: " ")
            let outputQuantity = Int(outputQuantityChemical[0])!
            let outputChemical = String(outputQuantityChemical[1])
            
            return ReactionRecipe(input: reactionInputs, outputChemical: outputChemical, outputQuantity: outputQuantity)
        }
    }
    
    private class ChemicalFactory {
        var chemicalStorage = ChemicalStorage()
        var consumedChemicals = [String: Int]()
        var recipes = [ReactionRecipe]()

        @discardableResult
        func generateChemical(chemical: String, quantity: Int) -> Bool {
            guard let recipe = self.recipes.first(where: {$0.outputChemical == chemical}) else { return false }
            var numberOfReactions = quantity / recipe.outputQuantity
            if quantity % recipe.outputQuantity != 0 {
                numberOfReactions += 1
            }
            
            for input in recipe.input {
                let requiredQuantity = input.quantity * numberOfReactions
                while !self.chemicalStorage.withdrawChemical(chemical: input.chemical, quantity: requiredQuantity) {
                    let quantityToGenerate = requiredQuantity - self.chemicalStorage.quantityOf(chemical: input.chemical)
                    let generated = self.generateChemical(chemical: input.chemical, quantity: quantityToGenerate)
                    if !generated { return false }
                }
                self.consumeChemical(chemical: input.chemical, quantity: requiredQuantity)
            }
            self.chemicalStorage.storeChemical(chemical: recipe.outputChemical, quantity: recipe.outputQuantity * numberOfReactions)
            return true
        }

        func consumeChemical(chemical: String, quantity: Int) {
            self.consumedChemicals[chemical] = (self.consumedChemicals[chemical] ?? 0) + quantity
        }

        func reset(oreQuantity: Int) {
            self.consumedChemicals = [:]
            self.chemicalStorage.chemicals = [:]
            self.chemicalStorage.resetOreQuantity(quantity: oreQuantity)
        }
    }
    
    private var chemicalFactory = ChemicalFactory()
    
    func loadInput() {
        let lines = FileLoader.loadText(fileName: "Day14Input")
        let recipes = lines.map({ReactionRecipe.from(string: $0)})
        self.chemicalFactory.recipes = recipes
    }
    
    func solveFirst() {
        self.chemicalFactory.generateChemical(chemical: "FUEL", quantity: 1)
        self.setSolution1("\(self.chemicalFactory.consumedChemicals["ORE"]!)")
    }
    
    func solveSecond() {
        var currentMinQuantity = 0
        var currentMaxQuantity = 1_000_000_000_000
        var bestGenerated = 0
        
        while currentMinQuantity != currentMaxQuantity {
            self.chemicalFactory.reset(oreQuantity: 1_000_000_000_000)
            let currentQuantity = (currentMinQuantity + currentMaxQuantity) / 2
            let generated = self.chemicalFactory.generateChemical(chemical: "FUEL", quantity: currentQuantity)
            if generated {
                bestGenerated = currentQuantity
                currentMinQuantity = currentQuantity + 1
            } else {
                currentMaxQuantity = currentQuantity
            }
        }
        
        self.setSolution2("\(bestGenerated)")
    }
}
