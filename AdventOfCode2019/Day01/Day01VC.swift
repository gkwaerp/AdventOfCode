//
//  Day01VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 30/11/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day01VC: UIViewController {
    private struct Monster: Codable {
        let age: Int
        let hp: Int
    }
    
    private var monsters = [Monster]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .green

        self.loadMonsters()
    }

    private func loadMonsters() {
        self.monsters = FileLoader.loadJSON(fileName: "Day01Input", parseType: [Monster].self)
    }
}
