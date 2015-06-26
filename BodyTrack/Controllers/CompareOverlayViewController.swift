//
//  CompareOverlayViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 26/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class CompareOverlayViewController: UIViewController {

    @IBOutlet var topImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topImageView.layer.borderColor = UIColor.darkGrayColor().CGColor
        topImageView.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }


    @IBAction func panGesture(recognizer: UIPanGestureRecognizer)
    {
        
        var translation = recognizer.translationInView(self.topImageView)
        
        recognizer.setTranslation(CGPointMake(0, 0), inView: self.topImageView)
        
        var center = recognizer.view?.center
        center?.y += translation.y
        center?.x += translation.x
        recognizer.view?.center = center!
        

    }
}
