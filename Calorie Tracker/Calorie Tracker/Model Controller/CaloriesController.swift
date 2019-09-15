//
//  CaloriesController.swift
//  Calorie Tracker
//
//  Created by Seschwan on 9/13/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import CoreData

extension NSNotification.Name {
    static let updatedCalories = NSNotification.Name("updatedCalories")
}

class CaloriesController {
    
    //var caloriesArray = [Calorie]()
    
    func addCalories(calorieCount: Double) {
        let newCalorieAmount = Calorie(calorieCount: calorieCount)
        //caloriesArray.append(newCalorieAmount) // We don't need this now since it will be saved in the main context?
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("There was an error saving MOC: \(error)")
            moc.reset()
        }
    }
    
    func deleteCalorie(calorie: Calorie) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(calorie)
        do {
            try moc.save()
        } catch {
            NSLog("There was an error deleting Calorie in Delete Method")
        }
    }
}
