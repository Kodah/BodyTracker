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
    @IBOutlet var slider: UISlider!
    
    var lastScale : CGFloat?
    var lastPoint : CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topImageView.layer.borderColor = UIColor.darkGrayColor().CGColor
        topImageView.layer.borderWidth = 2
        
        // Do any additional setup after loading the view.
    }


    @IBAction func pinchGesture(recognizer: UIPinchGestureRecognizer)
    {

        
        if recognizer.numberOfTouches() >= 2
        {
            if recognizer.state == UIGestureRecognizerState.Began
            {
                self.lastScale = 1.0
                self.lastPoint = recognizer.locationInView(recognizer.view)
            }
        }
        
        var scale = 1.0 - (self.lastScale! - recognizer.scale)
        
        self.topImageView.layer.setAffineTransform(CGAffineTransformScale(self.topImageView.layer.affineTransform(), scale, scale))
        
        
        self.lastScale = recognizer.scale
        
        var point = recognizer.locationInView(recognizer.view)
        
        self.topImageView.layer.setAffineTransform(
            CGAffineTransformTranslate(
                self.topImageView.layer.affineTransform(),
                point.x - self.lastPoint!.x,
                point.y - self.lastPoint!.y))
        
        self.lastPoint = recognizer.locationInView(recognizer.view)

    }

    @IBAction func panGesture(recognizer: UIPanGestureRecognizer)
    {
        
        var translation = recognizer.translationInView(self.topImageView)
        
        recognizer.setTranslation(CGPointMake(0, 0), inView: self.topImageView)
        
        var center = self.topImageView.center
        center.y += translation.y
        center.x += translation.x
        self.topImageView.center = center
        

    }
    
    @IBAction func sliderValueChanged(slider: UISlider)
    {
        self.topImageView.alpha = CGFloat(slider.value)
    }
    
}
