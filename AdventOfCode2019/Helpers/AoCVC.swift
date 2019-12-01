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

    private var startTime = Date()
    private var solution1Time = Date()

    private var label: UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground

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

        self.startTime = Date()
    }

    func setSolution1(_ text: String) {
        self.solution1Time = Date()
        let fullText = "\(text) (\(self.getElapsedTimeString(from: self.startTime)))"
        self.solution1Label.text = fullText
        print("\(self.title!) Solution 1: \(fullText)")
    }

    func setSolution2(_ text: String) {
        let fullText = "\(text) -- (\(self.getElapsedTimeString(from: self.solution1Time)))"
        self.solution2Label.text = fullText
        print("\(self.title!) Solution 2: \(fullText)")
    }

    private func getElapsedTimeString(from date: Date) -> String {
        let elapsedTime = Date().timeIntervalSince(date)
        return String(format: "%.4f", elapsedTime)
    }
}
