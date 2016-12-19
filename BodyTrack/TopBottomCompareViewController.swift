//
//  TopBottomCompareViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 02/07/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class TopBottomCompareViewController: UIViewController {
    
    
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var bottomImageView: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let tabBar = tabBarController as? CompareTabViewController, let progressPointToCompare = tabBar.progressPointsToCompare
        {
            topImageView.image = progressPointToCompare.firstProgressPoint.getImage()
            bottomImageView.image = progressPointToCompare.secondProgressPoint.getImage()
        }
    }
}
