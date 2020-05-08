//
//  CoreDataClient.swift
//  thereYet
//
//  Created by Clement Wekesa on 26/04/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataClient {
//    let managedContext: NSManagedObjectContext

    init() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
    }
}
