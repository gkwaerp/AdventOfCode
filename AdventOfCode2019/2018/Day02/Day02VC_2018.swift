//
//  Day02VC_2018.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day02VC_2018: AoCVC {
    var boxIds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInput()
        self.solveFirst()
        self.solveSecond()
    }

    private func loadInput() {
        self.boxIds = FileLoader.loadText(fileName: "Day2Input_2018")
//        self.boxIds = ["abcde",
//                       "fghij",
//                       "klmno",
//                       "pqrst",
//                       "fguij",
//                       "axcye",
//                       "wvxyz"]
    }

    private func solveFirst() {
        var count2 = 0
        var count3 = 0

        self.boxIds.forEach { (id) in
            var contains2 = false
            var contains3 = false
            id.forEach { (c) in
                let char = String(c)
                if id.replacingOccurrences(of: char, with: "").count == id.count - 2 {
                    contains2 = true
                }
                if id.replacingOccurrences(of: char, with: "").count == id.count - 3 {
                    contains3 = true
                }
            }
            count2 += contains2 ? 1 : 0
            count3 += contains3 ? 1 : 0
        }

        let checksum = count2 * count3
        self.setSolution1("\(checksum)")
    }

    private func solveSecond() {
        var alreadySeen = [Set<String>]()

        for charPositionIndex in 0..<(self.boxIds.first?.count ?? 0) {
            alreadySeen.append(Set<String>())
            for id in self.boxIds {
                guard !id.isEmpty else { continue }
                var filteredId = id
                filteredId.remove(at: String.Index(utf16Offset: charPositionIndex, in: id))
                if alreadySeen[charPositionIndex].contains(filteredId) {
                    self.setSolution2(filteredId)
                    return
                } else {
                    alreadySeen[charPositionIndex].insert(filteredId)
                }
            }
        }
    }
}
