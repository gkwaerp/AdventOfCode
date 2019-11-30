//
//  ViewController.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 30/11/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let mainStackView = UIStackView()
    var subStackViews = [UIStackView]()
    
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
            let stackViewIndex = i / 6
            self.subStackViews[stackViewIndex].addArrangedSubview(button)
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        var vc: UIViewController? = nil
        switch sender.tag {
        case 1: vc = Day01VC()
        default: break
        }
        
        if let vc = vc {
            vc.modalPresentationStyle = .overFullScreen
            vc.title = String(format: "Day %02d", sender.tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

