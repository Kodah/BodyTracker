//
//  ProgressCollection+CoreDataProperties.swift
//  BodyTrack
//
//  Created by lord on 12/01/2017.
//  Copyright © 2017 Tom Sugarex. All rights reserved.
//

import Foundation
import CoreData


extension ProgressCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressCollection> {
        return NSFetchRequest<ProgressCollection>(entityName: "ProgressCollection");
    }

    @NSManaged public var colour: String?
    @NSManaged public var identifier: String?
    @NSManaged public var interval: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var progressPoints: NSSet?

}

// MARK: Generated accessors for progressPoints
extension ProgressCollection {

    @objc(addProgressPointsObject:)
    @NSManaged public func addToProgressPoints(_ value: ProgressPoint)

    @objc(removeProgressPointsObject:)
    @NSManaged public func removeFromProgressPoints(_ value: ProgressPoint)

    @objc(addProgressPoints:)
    @NSManaged public func addToProgressPoints(_ values: NSSet)

    @objc(removeProgressPoints:)
    @NSManaged public func removeFromProgressPoints(_ values: NSSet)

}
