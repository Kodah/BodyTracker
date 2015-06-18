//
//  PhotoSelectionCollectionViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 14/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import CoreData



class PhotoSelectionCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MenuTableViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate {

    let reuseIdentifier = "Cell"
    let ProgressPointSegueId = "showProgressPointId"
    let bodyReuseIdentifier = "BodyCollectionViewCellId"
    let addReuseIdentifier = "AddCollectionViewId"
    var progressCollection : ProgressCollection?
    var progressPoints = [ProgressPoint]()
    var context: NSManagedObjectContext?
    
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
                    }
                }
                
                
            }
            self.title = progressCollection.name
            
        }

            
        self.clearsSelectionOnViewWillAppear = true
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {

        return self.progressPoints.count + 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell: UICollectionViewCell
        
        if (indexPath.row == self.progressPoints.count)
        {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(addReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
            cell.layer.borderColor = UIColor.purpleColor().CGColor;
            cell.layer.borderWidth = 1.0
        }
        else
        {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(bodyReuseIdentifier, forIndexPath: indexPath)as! UICollectionViewCell
            
            cell.contentView.frame = cell.bounds
            cell.contentView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
            
            cell.layer.borderColor = UIColor.purpleColor().CGColor;
            cell.layer.borderWidth = 1.0
        }

    
        return cell
    }
    
    func setBackgrounColour()
    {
        self.view.backgroundColor = UIColor.blackColor()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(16, 16, 8, 16)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let padding:CGFloat = 8 * 3
        let side:CGFloat = CGRectGetWidth(collectionView.frame) / 2
        let sideMinusPadding:CGFloat = side - padding
        return CGSizeMake(sideMinusPadding, sideMinusPadding + 44)
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 8
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.row == self.progressPoints.count)
        {
            
            let actionSheet = UIActionSheet(title: "New photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Use Camera", "Photo library")
            
            actionSheet.showInView(self.view)
            
//            var newProgressPoint :ProgressPoint = NSEntityDescription.insertNewObjectForEntityForName("ProgressPoint", inManagedObjectContext: self.context!) as! ProgressPoint
//            
//            newProgressPoint.progressCollection = self.progressCollection
//            
//            if let proCol = self.progressCollection
//            {
//                var copyProgressCollection : ProgressCollection = proCol
//                self.loadProgressPointsForProgressCollection(copyProgressCollection)
//            }
            
        }
    }
    
    func newProgressCollectionCreated(progressCollection: ProgressCollection)
    {
        self.progressCollection = progressCollection
        
        slidingViewController().resetTopViewAnimated(true)
        
        var alert = UIAlertView(title: "Edit collection name", message: "", delegate: self, cancelButtonTitle: "Delete", otherButtonTitles: "OK")

        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        
        alert.show()
        
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
        }
        
        self.title = progressCollection.name
        self.collectionView?.reloadData()
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
    
}















