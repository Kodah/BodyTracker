//
//  BodyTrackTests.swift
//  BodyTrackTests
//
//  Created by Tom Sugarex on 13/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import XCTest
import CoreData

@testable import BodyTrack


extension XCTestCase {
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}

class BodyTrackTests: XCTestCase {
    
    var managedObjectContext: NSManagedObjectContext?
    var progressPoint: ProgressPoint?
    let date = NSDate()
    let bodyFat = 10
    let measurement = 12
    let weight = 14
    
    override func setUp() {
        super.setUp()
        
        if managedObjectContext == nil {
            managedObjectContext = setUpInMemoryManagedObjectContext()
        }
        let entity = NSEntityDescription.entity(forEntityName: "ProgressPoint", in:managedObjectContext!)
        progressPoint = ProgressPoint(entity: entity!, insertInto: managedObjectContext)
        
        progressPoint?.date = date
        progressPoint?.bodyFat = bodyFat as NSNumber!
        progressPoint?.measurement = measurement as NSNumber!
        progressPoint?.weight = weight as NSNumber!

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        XCTAssertEqual(progressPoint?.description,
                       "Date: \(Date()) \nMeasurement: \(12)cm \nWeight: \(14)kg \nBody fat: \(10)% \n")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
