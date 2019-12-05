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

    private let enabledDays = Set([1, 2, 3, 4, 5])
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
        button.isEnabled = self.enabledDays.contains(day)
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
        var vc: UIViewController? = nil
        switch sender.tag {
        case 1: vc = Day01VC()
        case 2: vc = Day02VC()
        case 3: vc = Day03VC()
        case 4: vc = Day04VC()
        case 5: vc = Day05VC()
        default: break
        }
        
        if let vc = vc {
            vc.modalPresentationStyle = .overFullScreen
            vc.title = String(format: "Day %02d", sender.tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

