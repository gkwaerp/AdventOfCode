//
//  Day01VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 30/11/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day01VC: AoCVC {
    private var modules = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadModules()
        self.solveFirst()
        self.solveSecond()
    }

    private func loadModules() {
        self.modules = FileLoader.loadText(fileName: "Day01Input").compactMap({Int($0)})
    }

    private func solveFirst() {
        let fuel = self.modules.reduce(0, {$0 + self.getFuel(for: $1)})
        self.setSolution1("\(fuel)")
    }

    private func getFuel(for mass: Int) -> Int {
        return mass / 3 - 2
    }

    private func solveSecond() {
        var totalFuel = 0
        for module in self.modules {
            var fuelToAdd = self.getFuel(for: module)
            while fuelToAdd > 0 {
                totalFuel += fuelToAdd
                fuelToAdd = self.getFuel(for: fuelToAdd)
            }
        }
        self.setSolution2("\(totalFuel)")
    }
}
