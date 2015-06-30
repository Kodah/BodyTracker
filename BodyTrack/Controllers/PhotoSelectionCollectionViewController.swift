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

class PhotoSelectionCollectionViewController: UICollectionViewController, MenuTableViewControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate {

    let SegueToCompareTabBar : String = "GoToCompareSegueId"
    let SegueToEditCollection : String = "EditProgressCollectionSegue"
    
    @IBOutlet var imagePickerControllerHelper: ImagePickerControllerHelper!
    @IBOutlet var progressPointCollectionViewHelper: ProgressPointCollectionViewHelper!

    var progressCollection : ProgressCollection?
    var progressPoints = [ProgressPoint]()
    var context: NSManagedObjectContext?
    var selectedProgressCollection : ProgressCollection?
    var selectedProgressPoint : ProgressPoint?
    var alertController : UIAlertController?
    
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
            

            var button : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            
            
            var image = UIImage(named: "muscle")
            image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            button.setImage(image, forState: UIControlState.Normal)
            button.frame = CGRectMake(0, 0, 25, 25)
            button.addTarget(self, action: "rightBarButtonItemTapped", forControlEvents: UIControlEvents.TouchUpInside)
            button.imageView?.tintColor = UIColor.whiteColor()
            
            var rightBarButtonItem = UIBarButtonItem(customView: button)

            
           self.navigationItem.rightBarButtonItem = rightBarButtonItem
            
            
            
            var tapNavGesture = UITapGestureRecognizer(target: self, action: "navBarTapped")
            self.navigationController?.navigationBar.addGestureRecognizer(tapNavGesture)
        }
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        var copyCollection = self.progressCollection
        self.loadProgressPointsForProgressCollection(nil)
        
        self.progressPointCollectionViewHelper.collectionView.performBatchUpdates({ () -> Void in
            self.progressPointCollectionViewHelper.collectionView.reloadData()
        }, completion: { (Bool) -> Void in })
        
    }
    
    func navBarTapped()
    {
        self.performSegueWithIdentifier(SegueToEditCollection, sender: self)
    }
    
    func openMenu()
    {
        if self.slidingViewController().currentTopViewPosition == ECSlidingViewControllerTopViewPosition.Centered
        {
            self.slidingViewController().anchorTopViewToRightAnimated(true)
        }
        else
        {
            self.slidingViewController().resetTopViewAnimated(true)
        }
        
    }
    
    func rightBarButtonTapped()
    {
        self.performSegueWithIdentifier(SegueToCompareTabBar, sender: self)
    }
    
    func initiateNewProgressCollection()
    {
        slidingViewController().resetTopViewAnimated(true)
        self.setupAlertController()        
    }
    
    func setupAlertController()
    {
        self.alertController = UIAlertController(title: "New Collection", message: "Edit name", preferredStyle: UIAlertControllerStyle.Alert)
        
        var nameTextField : UITextField?
        
        self.alertController!.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "name"
            nameTextField = textField
            nameTextField?.delegate = self
            nameTextField?.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (_) -> Void in
            self.slidingViewController().anchorTopViewToRightAnimated(true)
        }
        var OKAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
            if let name = nameTextField?.text
            {
                self.createNewProgressCollectionWithName(name)
            }
        }
        
        OKAction.enabled = false
        self.alertController!.addAction(cancelAction)
        self.alertController!.addAction(OKAction)
        
        self.presentViewController(self.alertController!, animated: true, completion: nil)
    }
    
    func textFieldChanged(textField : UITextField)
    {
        if let alertController = self.alertController
        {
            if count(textField.text) > 0
            {
                if let actions = alertController.actions as? [UIAlertAction]
                {
                    for action in actions
                    {
                        action.enabled = true
                    }
                }
            }
            else
            {
                if let actions = alertController.actions as? [UIAlertAction]
                {
                    actions[1].enabled = false
                }
            }
        }
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
    
    func loadProgressPointsForProgressCollection(progressCollection: ProgressCollection?) {
        
        if let progressCollection = progressCollection
        {
            self.progressCollection = progressCollection
        }
        
        if let safeProgressCollection = self.progressCollection
        {
            let fetchRequest = NSFetchRequest(entityName: "ProgressPoint")
            let predicate = NSPredicate(format: "progressCollection == %@", safeProgressCollection)
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            fetchRequest.predicate = predicate
            
            if let context = self.context
            {
                self.progressPoints = context.executeFetchRequest(fetchRequest, error: nil) as! [ProgressPoint]
                self.progressPointCollectionViewHelper.progressPoints = self.progressPoints
            }
            
            self.title = safeProgressCollection.name
            self.navigationController?.navigationBar.translucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(rgba: safeProgressCollection.colour)
            
            self.collectionView?.reloadData()
        }
    }

    func showActionSheet()
    {
        let actionSheet = UIActionSheet(title: "New photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Use Camera", "Photo library")
        
        actionSheet.showInView(self.view)
    }
    
    func createNewProgressCollectionWithName(name : String?)
    {
        if let context = self.context
        {
            var newProgressCollection :ProgressCollection = NSEntityDescription.insertNewObjectForEntityForName("ProgressCollection", inManagedObjectContext: context) as! ProgressCollection
            newProgressCollection.name = name
            newProgressCollection.colour = UIColor.hexValuesFromUIColor(UIColor.randomColor())
            context.save(nil)
            self.loadProgressPointsForProgressCollection(newProgressCollection)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!
        {
        case "ShowProgressPointDetailId":
        
            var viewController = segue.destinationViewController as! ProgressPointDetailTableViewController
            viewController.progressPoint = self.selectedProgressPoint
            
            if let context = self.context
            {
                viewController.context = context
            }
            
        case SegueToEditCollection:
            var viewController = segue.destinationViewController.childViewControllers.first as! EditProgressCollectionViewController
            
            if let context = self.context
            {
                viewController.context = context
            }
            if let progressCollection = self.progressCollection
            {
                viewController.progressCollection = progressCollection
            }
        default:
                break;
        }
    }
    
}















