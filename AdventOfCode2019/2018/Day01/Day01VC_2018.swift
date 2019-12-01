//
//  Day01VC_2018.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day01VC_2018: AoCVC {
    var frequencyChanges = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadFrequencies()
        self.solveFirst()
        self.solveSecond()
    }

    private func loadFrequencies() {
        self.frequencyChanges = FileLoader.loadText(fileName: "Day1Input_2018").compactMap({Int($0)})
    }

    private func solveFirst() {
        let result = self.frequencyChanges.reduce(0, +)
        self.setSolution1("\(result)")
    }

    private func solveSecond() {
        var set = Set<Int>()
        var currentFrequency = 0
        while (true) {
            for change in self.frequencyChanges {
                if set.contains(change) {
                    self.setSolution2("\(currentFrequency)")
                    return
                } else {
                    set.insert(currentFrequency)
                }
                currentFrequency += change
            }
        }
    }
}
