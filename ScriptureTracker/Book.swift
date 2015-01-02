//
//  Book.swift
//  ScriptureTracker
//
//  Created by Michael Patterson on 1/2/15.
//  Copyright (c) 2015 Michael Patterson. All rights reserved.
//

import Foundation
import CoreData

class Book: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var subBooks: NSSet

}
