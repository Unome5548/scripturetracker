//
//  Reading.swift
//  ScriptureTracker
//
//  Created by Michael Patterson on 12/29/14.
//  Copyright (c) 2014 Michael Patterson. All rights reserved.
//

import Foundation
import CoreData

class Reading: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var minutes: NSNumber
    @NSManaged var chapters: NSNumber
    @NSManaged var type: NSString

}
