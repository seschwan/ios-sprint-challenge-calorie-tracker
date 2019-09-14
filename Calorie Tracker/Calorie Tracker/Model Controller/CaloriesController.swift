//
//  CaloriesController.swift
//  Calorie Tracker
//
//  Created by Seschwan on 9/13/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import SwiftChart

class CaloriesController {
    
    var caloriesArray = [Calorie]()
    
    func addCalories(calorieCount: Double) {
        let newCalorieAmount = Calorie(calorieCount: calorieCount)
        caloriesArray.append(newCalorieAmount)
    }
    
    func loadChart() {
        let chart = Chart()
        let series = ChartSeries([100, 200])
        chart.add(series)
        chart.backgroundColor = .red
    }
}
