//
//  PhotoSelectionCollectionViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 14/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import CoreData



class PhotoSelectionCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

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
        
        
        
        if let progressCollection = self.progressCollection
        {
            let fetchRequest = NSFetchRequest(entityName: "ProgressPoint")
            let predicate = NSPredicate(format: "ProgressCollection == %@", progressCollection)
            
            fetchRequest.predicate = predicate
            
            if let context = self.context
            {
                self.progressPoints = context.executeFetchRequest(fetchRequest, error: nil) as! [ProgressPoint]
            }
            
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
        self.performSegueWithIdentifier(ProgressPointSegueId, sender: self)
    }
    
}















