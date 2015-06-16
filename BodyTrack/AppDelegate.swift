//
//  AppDelegate.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 13/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let slidingViewController = storyboard.instantiateViewControllerWithIdentifier("slidingViewControllerId") as ECSlidingViewController;
        let topViewController = storyboard.instantiateViewControllerWithIdentifier("homeNavigationControllerId") as UIViewController
        let underLeftViewController = storyboard.instantiateViewControllerWithIdentifier("menuTableViewControllerId") as UIViewController
        
        let navigationController = UINavigationController(rootViewController: topViewController);
        
        underLeftViewController.view.layer.backgroundColor = UIColor(white: 0.9, alpha: 1).CGColor
        underLeftViewController.view.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        underLeftViewController.edgesForExtendedLayout = UIRectEdge.Top | UIRectEdge.Bottom | UIRectEdge.Left
        
        slidingViewController.topViewController = navigationController
        slidingViewController.underLeftViewController = underLeftViewController
        navigationController.view.addGestureRecognizer(slidingViewController.panGesture)
        
        slidingViewController.anchorLeftRevealAmount = 50
        
        self.window?.rootViewController = slidingViewController
        
        self.window?.makeKeyAndVisible()
        
        self.setupContext()
        
        return true
    }

    
    func setupContext()
    {
        
        var context = self.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ProgressCollection")

        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [ProgressCollection] {
            
            if fetchResults.count > 0
            {
                print(fetchResults.first?.colour)
            }
            else
            {
                var progressCollection = NSEntityDescription.insertNewObjectForEntityForName("ProgressCollection", inManagedObjectContext: context!) as ProgressCollection
                
                progressCollection.colour = "red"
                progressCollection.interval = 30
                progressCollection.name = "front"
                context?.save(nil);
            }
        }
    }
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Sug.BodyTrack" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("BodyTrack", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("BodyTrack.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

