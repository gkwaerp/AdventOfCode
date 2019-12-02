//
//  Day01VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 30/11/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day01VC: AoCVC, AdventDay {
    private var modules = [Int]()

    func loadInput() {
        self.modules = FileLoader.loadText(fileName: "Day01Input").compactMap({Int($0)})
    }

    func solveFirst() {
        let fuel = self.modules.reduce(0, {$0 + self.getFuel(for: $1)})
        self.setSolution1("\(fuel)")
    }

    func solveSecond() {
        let fuel = self.modules.reduce(0, {$0 + self.getFuel(for: $1, recursive: true)})
        self.setSolution2("\(fuel)")
    }

    private func getFuel(for mass: Int, recursive: Bool = false) -> Int {
        let fuelToAdd = mass / 3 - 2
        guard fuelToAdd > 0 else { return 0 }
        return fuelToAdd + (recursive ? self.getFuel(for: fuelToAdd, recursive: recursive) : 0)
    }
}
