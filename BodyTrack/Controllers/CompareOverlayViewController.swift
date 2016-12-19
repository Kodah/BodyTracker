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
    
    var shareImage : UIImage?
    
    var lastScale : CGFloat?
    var lastPoint : CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topImageView.layer.borderColor = UIColor.gray.cgColor
        topImageView.layer.borderWidth = 2
        
        if let tabBar = tabBarController as? CompareTabViewController, let progressPointToCompare = tabBar.progressPointsToCompare
        {
            bottomImageView.image = progressPointToCompare.firstProgressPoint.getImage()
            topImageView.image = progressPointToCompare.secondProgressPoint.getImage()
            
            shareImage = UIImage.createCompareImage(progressPointToCompare.firstProgressPoint, progressPoint2: progressPointToCompare.secondProgressPoint, statsEnabled: true)
            
        }
        
        var leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(CompareOverlayViewController.dismissSelf))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(CompareOverlayViewController.showShareImageViewController))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem;
        
        

    }
    
    func dismissSelf()
    {
        dismiss(animated: true, completion: nil)
    }
    
    func showShareImageViewController()
    {
        if let image = shareImage
        {
            var message = "Shared from BodyTracker™ #LeetGains \n p.s Hi Si"
            
            var instagramActivity = UIActivity()
            
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            navigationController?.present(activityViewController, animated: true, completion: nil)
            
            activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
            
//            activityViewController.completionWithItemsHandler = { activity, success, items, error in
//            
//                if activity == UIActivityTypeSaveToCameraRoll
//                {
//                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                }
//                
//            }
        }
    }

    @IBAction func pinchGesture(_ recognizer: UIPinchGestureRecognizer)
    {

        
        if recognizer.numberOfTouches >= 2
        {
            if recognizer.state == UIGestureRecognizerState.began
            {
                lastScale = 1.0
                lastPoint = recognizer.location(in: recognizer.view)
            }
        }
        
        let scale = 1.0 - (lastScale! - recognizer.scale)
        
        topImageView.layer.setAffineTransform(topImageView.layer.affineTransform().scaledBy(x: scale, y: scale))
        
        
        lastScale = recognizer.scale
        
        let point = recognizer.location(in: recognizer.view)
        
        topImageView.layer.setAffineTransform(
            topImageView.layer.affineTransform().translatedBy(x: point.x - lastPoint!.x,
                y: point.y - lastPoint!.y))
        
        lastPoint = recognizer.location(in: recognizer.view)

    }

    @IBAction func panGesture(_ recognizer: UIPanGestureRecognizer)
    {
        
        let translation = recognizer.translation(in: topImageView)
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: topImageView)
        
        var center = topImageView.center
        center.y += translation.y
        center.x += translation.x
        topImageView.center = center
    }
    
    @IBAction func sliderValueChanged(_ slider: UISlider)
    {
        topImageView.alpha = CGFloat(slider.value)
    }
    
    @IBAction func resetBarButtonTapped(_ sender: UIBarButtonItem)
    {
        topImageView.transform = CGAffineTransform.identity
        topImageView.frame = bottomImageView.bounds
        topImageView.setNeedsLayout()
        topImageView.layoutIfNeeded()
    }
}
