//
//  AoCVC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class AoCVC: UIViewController {
    private var solution1Label: UILabel!
    private var solution2Label: UILabel!

    private var label: UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.constrainToSuperView(leading: 40, trailing: 40, top: 180, bottom: 180, useSafeArea: true)

        self.solution1Label = self.label
        self.solution2Label = self.label

        stackView.addArrangedSubview(self.solution1Label)
        stackView.addArrangedSubview(self.solution2Label)
    }

    func setSolution1(_ text: String) {
        self.solution1Label.text = text
        print("Solution 1: \(text)")
    }

    func setSolution2(_ text: String) {
        self.solution2Label.text = text
        print("Solution 2: \(text)")
    }
}
