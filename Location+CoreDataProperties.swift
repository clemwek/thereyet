//
//  Location+CoreDataProperties.swift
//  thereYet
//
//  Created by Clement Wekesa on 26/04/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var longitude: String?
    @NSManaged public var latitude: String?
    @NSManaged public var more: String?

}
