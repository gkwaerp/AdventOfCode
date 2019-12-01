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

    private let enabledDays = Set([1, 2])
    
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
        self.view.addSubview(self.mainStackView)
        
        self.mainStackView.constrainToSuperView()
        
        for _ in 0..<4 {
            let subStackView = UIStackView()
            subStackView.axis = .vertical
            subStackView.distribution = .fillEqually
            subStackView.alignment = .center
            self.mainStackView.addArrangedSubview(subStackView)
            self.subStackViews.append(subStackView)
        }
    }
    
    private func configureButtons() {
        for i in 0..<24 {
            let day = i + 1
            let button = UIButton(type: .system)
            button.setTitle("Day \(day)", for: .normal)
            button.tag = day
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.isEnabled = self.enabledDays.contains(day)
            let stackViewIndex = i % 4
            self.subStackViews[stackViewIndex].addArrangedSubview(button)
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        var vc: UIViewController? = nil
        switch sender.tag {
        case 1: vc = Day01VC_2018()
        case 2: vc = Day02VC_2018()
        default: break
        }
        
        if let vc = vc {
            vc.modalPresentationStyle = .overFullScreen
            vc.title = String(format: "Day %02d", sender.tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

