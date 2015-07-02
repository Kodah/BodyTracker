//
//  CompareOverlayViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 26/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class CompareOverlayViewController: UIViewController {

    @IBOutlet var bottomImageView: UIImageView!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var slider: UISlider!
    
    var lastScale : CGFloat?
    var lastPoint : CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topImageView.layer.borderColor = UIColor.grayColor().CGColor
        topImageView.layer.borderWidth = 2
        
        if let tabBar = tabBarController as? CompareTabViewController, progressPointToCompare = tabBar.progressPointsToCompare
        {
            bottomImageView.image = progressPointToCompare.firstProgressPoint.getImage()
            topImageView.image = progressPointToCompare.secondProgressPoint.getImage()
        }
        
        var barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "dismissSelf")
        
        navigationItem.leftBarButtonItem = barButtonItem

    }
    
    func dismissSelf()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func pinchGesture(recognizer: UIPinchGestureRecognizer)
    {

        
        if recognizer.numberOfTouches() >= 2
        {
            if recognizer.state == UIGestureRecognizerState.Began
            {
                lastScale = 1.0
                lastPoint = recognizer.locationInView(recognizer.view)
            }
        }
        
        var scale = 1.0 - (lastScale! - recognizer.scale)
        
        topImageView.layer.setAffineTransform(CGAffineTransformScale(topImageView.layer.affineTransform(), scale, scale))
        
        
        lastScale = recognizer.scale
        
        var point = recognizer.locationInView(recognizer.view)
        
        topImageView.layer.setAffineTransform(
            CGAffineTransformTranslate(
                topImageView.layer.affineTransform(),
                point.x - lastPoint!.x,
                point.y - lastPoint!.y))
        
        lastPoint = recognizer.locationInView(recognizer.view)

    }

    @IBAction func panGesture(recognizer: UIPanGestureRecognizer)
    {
        
        var translation = recognizer.translationInView(topImageView)
        
        recognizer.setTranslation(CGPointMake(0, 0), inView: topImageView)
        
        var center = topImageView.center
        center.y += translation.y
        center.x += translation.x
        topImageView.center = center
        

    }
    
    @IBAction func sliderValueChanged(slider: UISlider)
    {
        topImageView.alpha = CGFloat(slider.value)
    }
    
    @IBAction func resetBarButtonTapped(sender: UIBarButtonItem)
    {
        topImageView.transform = CGAffineTransformIdentity
        topImageView.frame = bottomImageView.bounds
        topImageView.setNeedsLayout()
        topImageView.layoutIfNeeded()
    }
}
