//
//  AppDelegate.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 13/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import CoreData
import ECSlidingViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        self.setupContext()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let slidingViewController =
            (storyboard.instantiateViewController(withIdentifier: "slidingViewControllerId")
                as? ECSlidingViewController)!
        let topViewController =
            (storyboard.instantiateViewController(withIdentifier: "homeNavigationControllerId")
                as? PhotoSelectionCollectionViewController)!
        let underLeftViewController =
            (storyboard.instantiateViewController(withIdentifier: "menuTableViewControllerId")
                as? MenuTableViewController)!

        let navigationController = UINavigationController(rootViewController: topViewController)

        navigationController.view.clipsToBounds = false
        navigationController.view.layer.shadowOpacity = 0.75
        navigationController.view.layer.shadowRadius = 10.0
        navigationController.view.layer.shadowColor = UIColor.black.cgColor

        underLeftViewController.context = self.managedObjectContext
        topViewController.context = self.managedObjectContext

        underLeftViewController.edgesForExtendedLayout = [.top, .bottom, .left]

        slidingViewController.topViewController = navigationController
        slidingViewController.underLeftViewController = underLeftViewController
        topViewController.view.addGestureRecognizer(slidingViewController.panGesture)

        underLeftViewController.delegate = topViewController

        slidingViewController.anchorLeftRevealAmount = 50

        self.window?.rootViewController = slidingViewController

        self.window?.makeKeyAndVisible()

        return true
    }

    func setupContext() {

        let request = ProgressCollection.fetchRequest() as NSFetchRequest<ProgressCollection>
        
        do {
            if let progressCollections = try managedObjectContext?.fetch(request) {
                
                
                if progressCollections.count > 0 {
                    print("ProgressCollection \'\(progressCollections.first!.name)\' found")
                } else {
                    createInitialProgressCollection()
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

    }
    
    func createInitialProgressCollection() {
        if let progressCollection =
            NSEntityDescription.insertNewObject(forEntityName: "ProgressCollection",
                                                into: managedObjectContext!) as? ProgressCollection {
            let color = UIColor(red:91/255.0, green:140/255.0, blue:231/255.0, alpha:1.0)
            let hex = UIColor.hexValuesFromUIColor(color)
            progressCollection.colour = hex
            progressCollection.interval = 2
            progressCollection.name = "front"
            progressCollection.identifier = UUID().uuidString
            do {
                try managedObjectContext?.save()
            } catch {}
        }
    }
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        /*
         * The directory the application uses to store the Core Data store file.
         * This code uses a directory named "Sug.BodyTrack" in the application's 
         * documents Application Support directory.
         */
         let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. 
        // It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "BodyTrack", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        /*  The persistent store coordinator for the application.
            This implementation creates and return a coordinator, having added the store for the application to it. 
            This property is optional since there are legitimate error conditions that could cause the creation of 
            the store to fail. Create the coordinator and store
        */
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(
            managedObjectModel: self.managedObjectModel
        )
        let url = self.applicationDocumentsDirectory.appendingPathComponent("BodyTrack.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."

        do {
        if try coordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: nil) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN",
                            code: 9999,
                            userInfo: dict as NSDictionary? as? [AnyHashable: Any] ?? [:])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. 
            // You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        } catch {}

        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application 
        // (which is already bound to the persistent store coordinator for the application.) 
        // This property is optional since there are legitimate error conditions that could 
        // cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {

            if moc.hasChanges {
                do {
                    try moc.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
    }

}
