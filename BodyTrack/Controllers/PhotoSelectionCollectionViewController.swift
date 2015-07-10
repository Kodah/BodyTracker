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

class ProgressPointsToCompare
{
    let firstProgressPoint : ProgressPoint
    let secondProgressPoint : ProgressPoint
    
    init(firstProgressPoint : ProgressPoint, secondProgressPoint : ProgressPoint)
    {
        if firstProgressPoint.date.compare(secondProgressPoint.date) == NSComparisonResult.OrderedAscending
        {
            self.firstProgressPoint = firstProgressPoint
            self.secondProgressPoint = secondProgressPoint
        }
        else
        {
            self.firstProgressPoint = secondProgressPoint
            self.secondProgressPoint = firstProgressPoint
        }
    }
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
    var selectMode : Bool = false
    var buttonForRightBarButton : UIButton?
    var progressPointsToCompare : ProgressPointsToCompare?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let context = context
        {
            let fetchRequest = NSFetchRequest(entityName: "ProgressCollection")
            var progressCollectionArray : [ProgressCollection] = context.executeFetchRequest(fetchRequest, error: nil) as! [ProgressCollection]
            progressCollection = progressCollectionArray.first
        }
        
        if let progressCollection = progressCollection, context = context
        {
            let fetchRequest = NSFetchRequest(entityName: "ProgressPoint")
            let predicate = NSPredicate(format: "progressCollection == %@", progressCollection)
            
            fetchRequest.predicate = predicate
                        
            var array = context.executeFetchRequest(fetchRequest, error: nil)
            
            if let arraySafe = array
            {
                if ((arraySafe.first?.isKindOfClass(ProgressPoint)) != nil)
                {
                    progressPoints = arraySafe as! [ProgressPoint]
                    progressPointCollectionViewHelper.progressPoints = progressPoints
                }
                
            }
            title = progressCollection.name
            navigationController?.navigationBar.translucent = false
            navigationController?.navigationBar.barTintColor = UIColor(rgba: progressCollection.colour)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            
            var barButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("openMenu"))
            
            navigationItem.leftBarButtonItem = barButtonItem
            
            collectionView?.allowsMultipleSelection = true
            
            buttonForRightBarButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
            if let button = buttonForRightBarButton
            {
                var image = UIImage(named: "muscle")
                image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                button.setImage(image, forState: UIControlState.Normal)
                button.frame = CGRectMake(0, 0, 25, 25)
                button.addTarget(self, action: "rightBarButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
                button.imageView?.tintColor = UIColor.whiteColor()
                
                var rightBarButtonItem = UIBarButtonItem(customView: button)
                navigationItem.rightBarButtonItem = rightBarButtonItem
            }
            
            
            
            
            var tapNavGesture = UITapGestureRecognizer(target: self, action: "navBarTapped")
            navigationController?.navigationBar.addGestureRecognizer(tapNavGesture)
        }
        clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        var copyCollection = progressCollection
        loadProgressPointsForProgressCollection(nil)
        
        progressPointCollectionViewHelper.collectionView.performBatchUpdates({ () -> Void in
            self.progressPointCollectionViewHelper.collectionView.reloadData()
            }, completion: { (Bool) -> Void in })
        
    }
    
    func navBarTapped()
    {
        performSegueWithIdentifier(SegueToEditCollection, sender: self)
    }
    
    func openMenu()
    {
        if slidingViewController().currentTopViewPosition == ECSlidingViewControllerTopViewPosition.Centered
        {
            slidingViewController().anchorTopViewToRightAnimated(true)
        }
        else
        {
            slidingViewController().resetTopViewAnimated(true)
        }
        
    }
    
    func rightBarButtonTapped()
    {
        if selectMode
        {
            navigationItem.title = progressCollection?.name
            buttonForRightBarButton?.imageView?.tintColor = UIColor.whiteColor()
            //deselect all cells
            progressPointCollectionViewHelper.deselectAllCellsInCollectionView()
        }
        else
        {
            navigationItem.title = "Select Two Cells"
            navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
            buttonForRightBarButton?.imageView?.tintColor = UIColor.yellowColor()
        }
        
        selectMode = !selectMode
        progressPointCollectionViewHelper.selectMode = selectMode
        
        //        self.performSegueWithIdentifier(SegueToCompareTabBar, sender: self)
    }
    
    func initiateNewProgressCollection()
    {
        slidingViewController().resetTopViewAnimated(true)
        setupAlertController()
    }
    
    func setupAlertController()
    {
        alertController = UIAlertController(title: "New Collection", message: "Edit name", preferredStyle: UIAlertControllerStyle.Alert)
        
        var nameTextField : UITextField?
        
        alertController!.addTextFieldWithConfigurationHandler { (textField) -> Void in
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
        alertController!.addAction(cancelAction)
        alertController!.addAction(OKAction)
        
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    func textFieldChanged(textField : UITextField)
    {
        if let alertController = alertController, actions = alertController.actions as? [UIAlertAction]
        {
            if count(textField.text) > 0
            {
                
                for action in actions
                {
                    action.enabled = true
                }
            }
            else
            {
                
                actions[1].enabled = false
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
            
            var imagePickerController = imagePickerControllerHelper.getCameraFromHelper()
            
            presentViewController(imagePickerController, animated: true, completion: nil)
            
            break
        case ActionSheetButton.PhotoLibrary.rawValue:
            println("Open photos to select photo")
            
            var imagePickerController = imagePickerControllerHelper.getImagePickerFromHelper()
            
            presentViewController(imagePickerController, animated: true, completion: nil)
            
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
        
        
        var newProgressPoint :ProgressPoint = NSEntityDescription.insertNewObjectForEntityForName("ProgressPoint", inManagedObjectContext: context!) as! ProgressPoint
        
        newProgressPoint.progressCollection = progressCollection
        newProgressPoint.imageName = fileName
        newProgressPoint.date = date
        
        NotificationFactory().scheduleNotificationForProgressCollection(newProgressPoint.progressCollection)
        
        var error : NSError?
        if context?.save(&error) == false
        {
            println("error \(error?.description)")
        }
        
        if let proCol = progressCollection
        {
            var copyProgressCollection : ProgressCollection = proCol
            loadProgressPointsForProgressCollection(copyProgressCollection)
        }
    }
    
    //menu delegate
    
    func loadProgressPointsForProgressCollection(progressCollection: ProgressCollection?) {
        
        if let progressCollection = progressCollection
        {
            self.progressCollection = progressCollection
        }
        
        if let safeProgressCollection = self.progressCollection, context = context
        {
            let fetchRequest = NSFetchRequest(entityName: "ProgressPoint")
            let predicate = NSPredicate(format: "progressCollection == %@", safeProgressCollection)
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            fetchRequest.predicate = predicate
            
            
            progressPoints = context.executeFetchRequest(fetchRequest, error: nil) as! [ProgressPoint]
            progressPointCollectionViewHelper.progressPoints = progressPoints
            
            
            title = safeProgressCollection.name
            navigationController?.navigationBar.translucent = false
            navigationController?.navigationBar.barTintColor = UIColor(rgba: safeProgressCollection.colour)
            
            collectionView?.reloadData()
        }
    }
    
    func showActionSheet()
    {
        let actionSheet = UIActionSheet(title: "New photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Use Camera", "Photo library")
        
        actionSheet.showInView(view)
    }
    
    func createNewProgressCollectionWithName(name : String?)
    {
        if let context = context
        {
            var newProgressCollection :ProgressCollection = NSEntityDescription.insertNewObjectForEntityForName("ProgressCollection", inManagedObjectContext: context) as! ProgressCollection
            newProgressCollection.name = name
            newProgressCollection.colour = UIColor.hexValuesFromUIColor(UIColor.randomColor())
            newProgressCollection.identifier = NSUUID().UUIDString
            context.save(nil)
            loadProgressPointsForProgressCollection(newProgressCollection)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!
        {
        case "ShowProgressPointDetailId":
            
            var viewController = segue.destinationViewController as! ProgressPointDetailTableViewController
            viewController.progressPoint = selectedProgressPoint
            
            if let context = context
            {
                viewController.context = context
            }
            
        case SegueToEditCollection:
            var viewController = segue.destinationViewController.childViewControllers.first as! EditProgressCollectionViewController
            
            if let context = context, progressCollection = progressCollection
            {
                viewController.context = context
                viewController.progressCollection = progressCollection
            }
        case SegueToCompareTabBar:

            var tabBar = segue.destinationViewController as! CompareTabViewController
            tabBar.progressPointsToCompare = progressPointsToCompare
            
        default:
            break;
        }
    }
    
}















