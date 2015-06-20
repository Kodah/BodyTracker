//
//  PhotoSelectionCollectionViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 14/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import CoreData

enum ActionSheetButton: Int
{
    case Camera = 1
    case PhotoLibrary
}

class PhotoSelectionCollectionViewController: UICollectionViewController, MenuTableViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate {

    @IBOutlet var imagePickerControllerHelper: ImagePickerControllerHelper!
    @IBOutlet var progressPointCollectionViewHelper: ProgressPointCollectionViewHelper!

    var progressCollection : ProgressCollection?
    var progressPoints = [ProgressPoint]()
    var context: NSManagedObjectContext?
    var selectedProgressCollection : ProgressCollection?
    var selectedProgressPoint : ProgressPoint?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let context = self.context
        {
            let fetchRequest = NSFetchRequest(entityName: "ProgressCollection")
            var progressCollectionArray : [ProgressCollection] = context.executeFetchRequest(fetchRequest, error: nil) as! [ProgressCollection]
            self.progressCollection = progressCollectionArray.first
        }

        if let progressCollection = self.progressCollection
        {
            let fetchRequest = NSFetchRequest(entityName: "ProgressPoint")
            let predicate = NSPredicate(format: "progressCollection == %@", progressCollection)
            
            fetchRequest.predicate = predicate
            
            if let context = self.context
            {
                var array = context.executeFetchRequest(fetchRequest, error: nil)
                
                if let arraySafe = array
                {
                    if ((arraySafe.first?.isKindOfClass(ProgressPoint)) != nil)
                    {
                        self.progressPoints = arraySafe as! [ProgressPoint]
                        self.progressPointCollectionViewHelper.progressPoints = self.progressPoints
                    }
                }
            }
            self.title = progressCollection.name
            self.navigationController?.navigationBar.translucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(rgba: progressCollection.colour)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            
            var barButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("openMenu"))
            
            self.navigationItem.leftBarButtonItem = barButtonItem
            
        }
        self.clearsSelectionOnViewWillAppear = true
    }
    
    
    func openMenu()
    {
        self.slidingViewController().anchorTopViewToRightAnimated(true)
    }
    
    func newProgressCollectionCreated(progressCollection: ProgressCollection)
    {
        self.progressCollection = progressCollection
        
        slidingViewController().resetTopViewAnimated(true)
        
        var alert = UIAlertView(title: "Edit collection name", message: "", delegate: self, cancelButtonTitle: "Delete", otherButtonTitles: "OK")

        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        
        alert.show()
        
    }
    
    // actionsheet delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex
        {
        case ActionSheetButton.Camera.rawValue:
            println("open custom camera")

            var imagePickerController = self.imagePickerControllerHelper.getCameraFromHelper()
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
            break
        case ActionSheetButton.PhotoLibrary.rawValue:
            println("Open photos to select photo")
            
            var imagePickerController = self.imagePickerControllerHelper.getImagePickerFromHelper()
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
            break
        default:
            break
        }
    }
    
    
    func createNewProgressPoint(image : UIImage)
    {
        let date : NSDate = NSDate()
  
        
        
        let fileManager = NSFileManager.defaultManager()
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let uuid = NSUUID().UUIDString
        
        let fileName = "\(uuid).png"
        
        var filePathToWrite = "\(paths)/\(fileName)"
        
        var imageData : NSData = UIImagePNGRepresentation(image)
        
        fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
        
        
        var newProgressPoint :ProgressPoint = NSEntityDescription.insertNewObjectForEntityForName("ProgressPoint", inManagedObjectContext: self.context!) as! ProgressPoint
        
        newProgressPoint.progressCollection = self.progressCollection
        newProgressPoint.imageName = fileName
        newProgressPoint.date = date
        
        var error : NSError?
        if self.context?.save(&error) == false
        {
            println("error \(error?.description)")
        }
        
        if let proCol = self.progressCollection
        {
            var copyProgressCollection : ProgressCollection = proCol
            self.loadProgressPointsForProgressCollection(copyProgressCollection)
        }
    }
    
    //menu delegate
    
    func loadProgressPointsForProgressCollection(progressCollection: ProgressCollection) {
        
        self.progressCollection = progressCollection
        
        let fetchRequest = NSFetchRequest(entityName: "ProgressPoint")
        let predicate = NSPredicate(format: "progressCollection == %@", progressCollection)
        
        fetchRequest.predicate = predicate
        
        if let context = self.context
        {
            self.progressPoints = context.executeFetchRequest(fetchRequest, error: nil) as! [ProgressPoint]
            self.progressPointCollectionViewHelper.progressPoints = self.progressPoints
        }
        
        self.title = progressCollection.name
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba: progressCollection.colour)
        
        self.collectionView?.reloadData()
    }

    func showActionSheet()
    {
        let actionSheet = UIActionSheet(title: "New photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Use Camera", "Photo library")
        
        actionSheet.showInView(self.view)
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex
        {
        case 0:
            println("delete progress collection and loads another one")
            break
            
        case 1:
            
            self.progressCollection?.name = alertView.textFieldAtIndex(0)?.text

            self.progressCollection?.colour = UIColor.hexValuesFromUIColor(UIColor.randomColor())
            self.loadProgressPointsForProgressCollection(self.progressCollection!)
            
            if let context = self.context
            {
                if self.context?.save(nil) == false
                {
                    println("save failed")
                }
            }
            
            break
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!
        {
        case "ShowProgressPointDetailId":
        
            var viewController = segue.destinationViewController as! ProgressPointDetailTableViewController
            viewController.progressPoint = self.selectedProgressPoint
        break
            
            
            
        default:
                break;
        }
    }
    
}















