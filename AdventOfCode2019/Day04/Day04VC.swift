//
//  Day04VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day04VC: AoCVC, AdventDay {

    struct Validator {
        var potentials = [Int]()
        
        private func matchesCriteria(number: Int, strict: Bool) -> Bool {
            let arrayedNumber = "\(number)".map({Int("\($0)")!})

            if arrayedNumber.count != 6 { return false }
            if !self.neverDescending(arrayedNumber: arrayedNumber) { return false }
            if !self.containsDoubles(arrayedNumber: arrayedNumber, strict: strict) { return false }
            
            return true
        }
    
        private func neverDescending(arrayedNumber: [Int]) -> Bool {
            var currentMin = 0
            for i in 0..<arrayedNumber.count {
                if arrayedNumber[i] < currentMin {
                    return false
                }
                if arrayedNumber[i] > currentMin {
                    currentMin = arrayedNumber[i]
                }
            }
            return true
        }

        private func containsDoubles(arrayedNumber: [Int], strict: Bool) -> Bool {
            var counts = [Int](repeating: 0, count: 10)
            for number in arrayedNumber {
                counts[number] += 1
            }
            
            for count in counts {
                if strict {
                    if count == 2 {
                        return true
                    }
                } else {
                    if count >= 2 {
                        return true
                    }
                }
            }
            return false
        }

        func test() {
            guard self.matchesCriteria(number: 111111, strict: false) == true else { fatalError() }
            guard self.matchesCriteria(number: 223450, strict: false) == false else { fatalError() }
            guard self.matchesCriteria(number: 123789, strict: false) == false else { fatalError() }
            guard self.matchesCriteria(number: 112233, strict: true) == true else { fatalError() }
            guard self.matchesCriteria(number: 123444, strict: true) == false else { fatalError() }
            guard self.matchesCriteria(number: 111122, strict: true) == true else { fatalError() }
        }

        func numMatching(strict: Bool) -> Int {
            self.potentials.map({self.matchesCriteria(number: $0, strict: strict)}).filter({$0 == true}).count
        }
    }

    var validator = Validator()
    
    func loadInput() {
        let inputRange = 264360...746325
        self.validator.potentials = Array(inputRange)
        self.validator.test()
    }
    
    func solveFirst() {
        let solution = self.validator.numMatching(strict: false)
        self.setSolution1("\(solution)")
    }
    
    func solveSecond() {
        let solution = self.validator.numMatching(strict: true)
        self.setSolution2("\(solution)")
    }
}
