//
//  Day01VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 30/11/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day01VC: UIViewController {
    private var frequencyChanges = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .green
        self.loadFrequencies()
        self.solveFirst()
        self.solveSecond()
    }

    private func loadFrequencies() {
        self.frequencyChanges = FileLoader.loadText(fileName: "Day01Input2").compactMap({Int($0)})
    }

    private func solveFirst() {
        print("Resulting Frequency = \(self.frequencyChanges.reduce(0, +))")
    }

    private func solveSecond() {
        var dictionary = [Int: Bool]()
        var currFrequency = 0
        while (true) {
            for frequency in self.frequencyChanges {
                if dictionary[currFrequency] != nil {
                    print("First repeated frequency = \(currFrequency)")
                    return
                } else {
                    dictionary[currFrequency] = true
                }
                currFrequency += frequency
            }
        }
    }
}
