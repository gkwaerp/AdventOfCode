//
//  DateHelper.swift
//  AdventOfCode2019
//
//  Created by Geir-Kåre S. Wærp on 03/11/2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

class DateHelper {
    static func getElapsedTimeString(from date: Date) -> String {
        let elapsedTime = Date().timeIntervalSince(date)
        return String(format: "Time = %.4f", elapsedTime)
    }
}
