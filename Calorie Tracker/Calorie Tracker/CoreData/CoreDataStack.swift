//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Seschwan on 9/14/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calories")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores in CoreDataStack: \(error)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
                NSLog("There was an error trying to save in Save Function in the CoreDataStack: \(String(describing: error))")
            }
        }
        if let error = error { throw error}
    }
}
