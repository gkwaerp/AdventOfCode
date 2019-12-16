//
//  ViewController.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 30/11/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Overview2019ViewController: UIViewController {
    private let mainStackView = UIStackView()
    private var subStackViews = [UIStackView]()

    private let verticalSpacing: CGFloat = 4
    private let horizontalSpacing: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Advent of Code 2019"
        
        self.configureStackViews()
        self.configureButtons()
    }
    
    private func configureStackViews() {
        self.mainStackView.axis = .horizontal
        self.mainStackView.distribution = .fillEqually
        self.mainStackView.alignment = .center
        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.mainStackView.spacing = self.horizontalSpacing
        self.view.addSubview(self.mainStackView)
        
        NSLayoutConstraint.activate([self.mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     self.mainStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
        
        for _ in 0..<4 {
            let subStackView = UIStackView()
            subStackView.axis = .vertical
            subStackView.distribution = .fillEqually
            subStackView.alignment = .center
            subStackView.spacing = self.verticalSpacing
            self.mainStackView.addArrangedSubview(subStackView)
            self.subStackViews.append(subStackView)
        }
    }

    private func makeAdventDayButton(day: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let dayString = String(format: "%02d", day)
        button.setTitle("Day \(dayString)", for: .normal)
        button.tag = day
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.isEnabled = (self.getViewController(for: day) != nil)
        return button
    }
    
    private func configureButtons() {
        for i in 0..<24 {
            let day = i + 1
            let stackViewIndex = i % 4
            self.subStackViews[stackViewIndex].addArrangedSubview(self.makeAdventDayButton(day: day))
        }
        
        let sillyButton = self.makeAdventDayButton(day: 25)
        self.view.addSubview(sillyButton)
        NSLayoutConstraint.activate([sillyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     sillyButton.topAnchor.constraint(equalTo: self.mainStackView.bottomAnchor, constant: self.verticalSpacing)])

        let button = UIButton(type: .system)
        button.setTitle("2018", for: .normal)
        button.addTarget(self, action: #selector(self.tapped2018), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        NSLayoutConstraint.activate([button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                     button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     button.heightAnchor.constraint(equalToConstant: 60)])
    }

    @objc private func tapped2018() {
        let vc = Overview2018ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        if let vc = self.getViewController(for: sender.tag) {
            vc.modalPresentationStyle = .overFullScreen
            vc.title = String(format: "Day %02d", sender.tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func getViewController(for day: Int) -> UIViewController? {
        switch day {
        case 1: return Day01VC()
        case 2: return Day02VC()
        case 3: return Day03VC()
        case 4: return Day04VC()
        case 5: return Day05VC()
        case 6: return Day06VC()
        case 7: return Day07VC()
        case 8: return Day08VC()
        case 9: return Day09VC()
        case 10: return Day10VC()
        case 11: return Day11VC()
        case 12: return Day12VC()
        case 13: return Day13VC()
        case 14: return Day14VC()
        case 15: return Day15VC()
        case 16: return Day16VC()
        default: return nil
        }
    }
}
