//
//  Craving.swift
//  Food Craving
//
//  Created by Ross Duris on 3/24/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit
import CoreData

class Craving: NSManagedObject {
    
    @NSManaged var title: String!
    @NSManaged var rating: Int
    @NSManaged var timestamp: String
    var slider: Slider?
    
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Craving", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        title = dictionary["title"] as! String
        rating = dictionary["rating"] as! Int
        timestamp = dictionary["timestamp"] as! String
    }
    
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
}