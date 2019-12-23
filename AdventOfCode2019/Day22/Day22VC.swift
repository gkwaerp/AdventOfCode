//
//  Day22VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 23/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day22VC: AoCVC, AdventDay {
    var cards = [Int]()
    var lines = [String]()
    
    func loadInput() {
        self.lines = FileLoader.loadText(fileName: "Day22Input")
        let numCards = 10007
        for i in 0..<numCards {
            cards.append(i)
        }
    }
    
    func dealIntoNewStack() {
        self.cards = self.cards.reversed()
    }
    
    func cut(numToCut: Int) {
        if numToCut > 0 {
            let prefix = cards.prefix(numToCut)
            let dropped = cards.dropFirst(numToCut)
            self.cards = Array(dropped + prefix)
        } else {
            let absNum = abs(numToCut)
            let suffix = cards.suffix(absNum)
            let dropped = cards.dropLast(absNum)
            self.cards = Array(suffix + dropped)
        }
    }
    
    func dealWithIncrement(increment: Int){
        let numToDeal = cards.count
        var newDeck = [Int](repeating: 0, count: numToDeal)
        var numDealt = 0
        var currIndex = 0
        while numDealt < numToDeal {
            newDeck[currIndex] = cards[numDealt]
            currIndex += increment
            currIndex %= numToDeal
            numDealt += 1
        }
        self.cards = newDeck
    }
    
    func solveFirst() {
        let numCards = self.cards.count
        for i in 0..<numCards {
            if self.cards[i] == 2019 {
                self.setSolution1("\(i)")
                break
            }
        }
    }
    
    func shuffle() {
        for line in self.lines {
            if line.contains("deal with") {
                let split = line.split(separator: " ")
                let increment = Int(split[3])!
                self.dealWithIncrement(increment: increment)
            } else if line == "deal into new stack" {
                self.dealIntoNewStack()
            } else {
                let split = line.split(separator: " ")
                let numToCut = Int(split[1])!
                self.cut(numToCut: numToCut)
            }
        }
    }
    
    func solveSecond() {
    }
}
