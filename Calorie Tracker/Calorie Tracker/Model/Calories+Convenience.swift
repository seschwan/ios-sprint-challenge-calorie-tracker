//
//  Calories+Convenience.swift
//  Calorie Tracker
//
//  Created by Seschwan on 9/14/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    
//    var calorieRep: CalorieRepresentation? {
//        guard let calories = self.calorieCount,
//            let timeStamp = self.timeStamp else { return nil }
//        return CalorieRepresentation(calorieCount: calories, timeStamp: timeStamp)
//    }
    
    convenience init(calorieCount: Double, timeStamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.calorieCount = calorieCount
        self.timeStamp = timeStamp
    }
    
}
