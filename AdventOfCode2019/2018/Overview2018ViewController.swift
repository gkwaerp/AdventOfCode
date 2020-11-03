//
//  Overview2018ViewController.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 01/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Overview2018ViewController: UIViewController {
    private let mainStackView = UIStackView()
    private var subStackViews = [UIStackView]()
    
    private let verticalSpacing: CGFloat = 4
    private let horizontalSpacing: CGFloat = 16

    //Days start at 1, not 0.
    private var calendarDays: [Int: AoCVC.Type] = [1 : Day01VC_2018.self,
                                                   2 : Day02VC_2018.self,
                                                   3 : Day03VC_2018.self,
                                                   4 : Day04VC_2018.self,
                                                   5 : Day05VC_2018.self,
                                                   6 : Day06VC_2018.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Advent of Code 2018"
        self.view.backgroundColor = .systemBackground
        
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
    }
    
    private func makeAdventDayButton(day: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let dayString = String(format: "%02d", day)
        button.setTitle("Day \(dayString)", for: .normal)
        button.tag = day
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.isEnabled = (self.calendarDays[day] != nil)
        return button
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        guard let vcType = self.calendarDays[sender.tag] else { fatalError("Invalid VC.") }
        let vc = vcType.init()
        vc.modalPresentationStyle = .overFullScreen
        vc.title = String(format: "Day %02d", sender.tag)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

