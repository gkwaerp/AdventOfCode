//
//  Day08VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 08/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day08VC: AoCVC, AdventDay {
    
    private var spaceImage: IntImage!
    
    func loadInput() {
        let line = FileLoader.loadText(fileName: "Day08Input").first!
        let ints = line.map({ Int("\($0)")! })
        self.spaceImage = IntImage(width: 25, height: 6, data: ints)
    }
    
    func solveFirst() {
        let layerIndex = self.spaceImage.getLayerIndexWithFewestMatching(color: .black)
        let num1 = self.spaceImage.getNumMatchingPixelsInLayer(layerIndex: layerIndex, color: .white)
        let num2 = self.spaceImage.getNumMatchingPixelsInLayer(layerIndex: layerIndex, color: .transparent)
        self.setSolution1("\(num1 * num2)")
    }
    
    func solveSecond() {
        let rasterized = self.spaceImage.rasterized
        let imageText = "\n\(rasterized.asText())"
        self.setSolution2(imageText)
    }
}
