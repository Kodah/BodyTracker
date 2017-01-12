//
//  ProgressPoint+CoreDataProperties.swift
//  BodyTrack
//
//  Created by lord on 12/01/2017.
//  Copyright © 2017 Tom Sugarex. All rights reserved.
//

import Foundation
import CoreData


extension ProgressPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressPoint> {
        return NSFetchRequest<ProgressPoint>(entityName: "ProgressPoint");
    }

    @NSManaged public var bodyFat: NSNumber?
    @NSManaged public var date: NSDate?
    @NSManaged public var identifier: String?
    @NSManaged public var imageName: String?
    @NSManaged public var measurement: NSNumber?
    @NSManaged public var weight: NSNumber?
    @NSManaged public var progressCollection: ProgressCollection?

}
