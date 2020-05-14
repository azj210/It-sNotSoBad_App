//
//  Sem+CoreDataProperties.swift
//  iOS_Final
//
//  Created by Alex Jiang on 11/22/19.
//  Copyright © 2019 Michelle Choi. All rights reserved.
//
//

import Foundation
import CoreData


extension Sem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sem> {
        return NSFetchRequest<Sem>(entityName: "Sem")
    }

    @NSManaged public var name: String?
    @NSManaged public var sem_gpa: Float
    @NSManaged public var newRelationship: Element?

}
