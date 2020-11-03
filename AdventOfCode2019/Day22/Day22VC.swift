//
//  Day22VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 23/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day22VC: AoCVC, AdventDay, InputLoadable {
    var cards = [Int]()
    var lines = [String]()
    
    func loadInput() {
        self.lines = "Day22Input".loadAsTextStringArray()
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
                self.setSolution(challenge: 0, text: "\(i)")
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
        let numCards = 119_315_717_514_047
        let numShuffles = 101_741_582_076_661
        for i in 0..<numCards {
            print("Card index \(i)")
            var index = i
            for _ in 0..<numShuffles {
                for line in self.lines {
                    if line.contains("deal with") {
                        let split = line.split(separator: " ")
                        let increment = Int(split[3])!
                        index = self.indexAfterDealWithIncrement(numCards: numCards, index: index, increment: increment)
                    } else if line == "deal into new stack" {
                        index = self.indexAfterDealIntoNewStack(numCards: numCards, index: index)
                    } else {
                        let split = line.split(separator: " ")
                        let numToCut = Int(split[1])!
                        index = self.indexAfterCut(numCards: numCards, index: index, numToCut: numToCut)
                    }
                }
            }
//            if index == 2020 {
//                self.setSolution2("\(i)")
//                return
//            }
        }
//        self.cards = [Int](repeating: 0, count: numCards)
//
//        for i in 0..<numCards {
//            self.cards[i] = i
//        }
//        let originalDeck = self.cards
//
//        let numShuffles = 101_741_582_076_661
//        for i in 0..<numShuffles {
//            if i % 10000 == 0 {
//                print("Shuffle: \(i + 1)")
//            }
//            self.shuffle()
//            if self.cards == originalDeck {
//                print("Same after \(i + 1) shuffles")
//            }
//        }
//
//        for i in 0..<numCards {
//            if self.cards[i] == 2020 {
//                self.setSolution2("\(i)")
//                break
//            }
//        }
    }
    
    func indexAfterDealIntoNewStack(numCards: Int, index: Int) -> Int {
        return (numCards - index) - 1
    }
    
    func indexAfterCut(numCards: Int, index: Int, numToCut: Int) -> Int {
        if numToCut > 0 {
            if index >= numToCut {
                return index - numToCut
            } else {
                let numNotCut = numCards - numToCut
                return numNotCut + index
            }
        } else {
            let absNum = abs(numToCut)
            let numNotCut = numCards - absNum
            if index < numNotCut {
                return absNum + index
            } else {
                return index - numNotCut
            }
        }
    }
    
    func indexAfterDealWithIncrement(numCards: Int, index: Int, increment: Int) -> Int {
        if index == 0 {
            return 0
        }
        
        return (increment * index) % numCards
    }
}
