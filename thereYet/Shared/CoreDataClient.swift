//
//  CoreDataClient.swift
//  thereYet
//
//  Created by Clement Wekesa on 26/04/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//

import CoreData
import Foundation
import MapKit
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

extension CoreDataClient {
    static func save(place: MKPlacemark) {

        let managedContext = CoreDataClient.contex

        let entity =
            NSEntityDescription.entity(forEntityName: "Location",
                                       in: managedContext)!

        let location = NSManagedObject(entity: entity,
                                       insertInto: managedContext)

        location.setValue(place.coordinate.latitude, forKeyPath: "latitude")
        location.setValue(place.coordinate.longitude, forKeyPath: "longitude")
        //TODO: Fix this
        location.setValue("place.more", forKey: "placeDescription")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
