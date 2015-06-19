//
//  ProgressPointCollectionViewHelper.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 18/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class ProgressPointCollectionViewHelper: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    let reuseIdentifier = "Cell"
    let ProgressPointSegueId = "showProgressPointId"
    let bodyReuseIdentifier = "BodyCollectionViewCellId"
    let addReuseIdentifier = "AddCollectionViewId"
    var progressPoints = [ProgressPoint]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoSelectionCollectionViewController: PhotoSelectionCollectionViewController!
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        println(self.progressPoints.count)
        return self.progressPoints.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        if (indexPath.row == self.progressPoints.count)
        {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier(addReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
            
                cell.layer.borderColor = UIColor.purpleColor().CGColor;
                cell.layer.borderWidth = 1.0
                
                return cell
        }
        else
        {
            
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier(bodyReuseIdentifier, forIndexPath: indexPath) as! ProgressPointCollectionViewCell

            var progressPoint: ProgressPoint = self.progressPoints[indexPath.row]
            
            if let imageView = cell.progressPicImageView
            {
                if let image = progressPoint.getImage()
                {
                    imageView.image = image
                }
            }
                    
            cell.contentView.frame = cell.bounds
            cell.contentView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                
            cell.layer.borderColor = UIColor.purpleColor().CGColor;
            cell.layer.borderWidth = 1.0
            return cell
        }
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.row == self.progressPoints.count)
        {
            self.photoSelectionCollectionViewController.showActionSheet()
        }
        else
        {
            self.photoSelectionCollectionViewController.selectedProgressPoint = self.progressPoints[indexPath.row]
            self.photoSelectionCollectionViewController.performSegueWithIdentifier("ShowProgressPointDetailId", sender: self.photoSelectionCollectionViewController)
        }
    }
}
