//
//  SubBook.swift
//  ScriptureTracker
//
//  Created by Michael Patterson on 1/2/15.
//  Copyright (c) 2015 Michael Patterson. All rights reserved.
//

import Foundation
import CoreData

class SubBook: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var chapters: NSNumber
    @NSManaged var sort: NSNumber
    @NSManaged var book: Book

}
