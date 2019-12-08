//
//  Day08VC.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 08/12/2019.
//  Copyright © 2019 GK. All rights reserved.
//

import UIKit

class Day08VC: AoCVC, AdventDay {
    private struct SpaceImage {
        struct Layer {
            var width: Int
            var height: Int
            var data: [Int]

            private func getIndex(x: Int, y: Int) -> Int {
                return y * width + x
            }

            func getPixel(x: Int, y: Int) -> Int {
                return self.data[self.getIndex(x: x, y: y)]
            }

            func getNumPixels(matching pixelValue: Int) -> Int {
                return self.data.filter({$0 == pixelValue}).count
            }

            func asText() -> String {
                var finalText = ""
                for y in 0..<self.height {
                    for x in 0..<self.width {
                        // 0 is black, 1 is white.
                        if self.getPixel(x: x, y: y) == 0 {
                            finalText.append(" ")
                        } else {
                            finalText.append("X")
                        }
                    }
                    finalText.append("\n")
                }
                return finalText
            }
        }

        var width: Int
        var height: Int
        var layers: [Layer]

        init(width: Int, height: Int, data: [Int]) {
            let pixelsPerLayer = width * height
            let numLayers = data.count / pixelsPerLayer
            var dataToUse = data
            var layers = [Layer]()
            for _ in 0..<numLayers {
                let layerData = Array(dataToUse.prefix(pixelsPerLayer))
                dataToUse = Array(dataToUse.dropFirst(pixelsPerLayer))
                layers.append(Layer(width: width, height: height, data: layerData))
            }

            self.width = width
            self.height = height
            self.layers = layers
        }

        func getLayerIndexWithFewestMatching(pixelValue: Int) -> Int {
            var fewestSoFar = self.width * self.height
            var bestIndex = -1
            for (index, layer) in self.layers.enumerated() {
                let matchingInLayer = layer.getNumPixels(matching: pixelValue)
                if matchingInLayer < fewestSoFar {
                    fewestSoFar = matchingInLayer
                    bestIndex = index
                }
            }
            return bestIndex
        }

        func getNumMatchingPixelsInLayer(layerIndex: Int, pixelValue: Int) -> Int {
            return self.layers[layerIndex].getNumPixels(matching: pixelValue)
        }

        lazy var rasterized: Layer = {
            var rasterizedData = [Int]()
            for y in 0..<self.height {
                for x in 0..<self.width {
                    rasterizedData.append(self.findPixel(x: x, y: y))
                }
            }
            return Layer(width: self.width, height: self.height, data: rasterizedData)
        }()

        private func findPixel(x: Int, y: Int) -> Int {
            for layer in self.layers {
                let pixelValue = layer.getPixel(x: x, y: y)
                if pixelValue != 2 {
                    return pixelValue
                }
            }
            return -1
        }
    }

    private var spaceImage: SpaceImage!

    func loadInput() {
        let line = FileLoader.loadText(fileName: "Day08Input").first!
        let ints = line.map({ Int("\($0)")! })
        self.spaceImage = SpaceImage(width: 25, height: 6, data: ints)
    }
    
    func solveFirst() {
        let layerIndex = self.spaceImage.getLayerIndexWithFewestMatching(pixelValue: 0)
        let num1 = self.spaceImage.getNumMatchingPixelsInLayer(layerIndex: layerIndex, pixelValue: 1)
        let num2 = self.spaceImage.getNumMatchingPixelsInLayer(layerIndex: layerIndex, pixelValue: 2)
        self.setSolution1("\(num1 * num2)")
    }
    
    func solveSecond() {
        let rasterized = self.spaceImage.rasterized
        let imageText = "\n\(rasterized.asText())"
        self.setSolution2(imageText)
    }
}
