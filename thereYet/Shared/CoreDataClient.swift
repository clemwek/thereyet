//
//  CoreDataClient.swift
//  thereYet
//
//  Created by Clement Wekesa on 26/04/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//

import CoreData
import Foundation
import UIKit

final class CoreDataClient {

    private init() {}

    static var contex: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "thereYet")
        container.loadPersistentStores (completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
