//
//  Day01VC_2018.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day01VC_2018: AoCVC, AdventDay, InputLoadable {
    private var frequencyChanges = [Int]()

    func loadInput() {
        self.frequencyChanges = "Day1Input_2018".loadAsTextStringArray().compactMap({Int($0)})
    }

    func solveFirst() {
        let result = self.frequencyChanges.reduce(0, +)
        self.setSolution(challenge: 0, text: "\(result)")
    }

    func solveSecond() {
        var set = Set<Int>()
        var currentFrequency = 0
        while (true) {
            for change in self.frequencyChanges {
                if !set.insert(currentFrequency).inserted {
                    self.setSolution(challenge: 1, text: "\(currentFrequency)")
                    return
                }
                currentFrequency += change
            }
        }
    }
}
