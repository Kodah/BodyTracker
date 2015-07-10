//
//  UIImage-helper.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 03/07/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import Foundation

extension UIImage
{
    
    class func createCompareImage(progressPoint1 : ProgressPoint, progressPoint2 : ProgressPoint, statsEnabled : Bool) -> UIImage
    {
        
        var image1 : UIImage = progressPoint1.getImage()!
        var image2 : UIImage = progressPoint2.getImage()!
        var size = CGSizeMake(image1.size.width * 2, image1.size.height)
        
        let font = UIFont.systemFontOfSize(16)
        
        UIGraphicsBeginImageContext(size)
        
        image1.drawInRect(CGRectMake(0, 0, image1.size.width, image1.size.height))
        image2.drawInRect(CGRectMake(image1.size.width, 0, image2.size.width, image2.size.height))
        
        if statsEnabled
        {
            let attributes = [
                NSFontAttributeName : font,
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSBackgroundColorAttributeName : UIColor.blackColor().colorWithAlphaComponent(0.5)
            ]
            
            var rectForLeftImageStats = CGRectMake(
                10,
                image1.size.height - 100,
                progressPoint1.getStats().sizeWithAttributes(attributes).width,
                100
            
            )
            
            
            progressPoint1.getStats().drawInRect(rectForLeftImageStats, withAttributes: attributes)
            
            var rectForRightImageStats = CGRectMake(
                image2.size.width + 10,
                image2.size.height - 100,
                progressPoint2.getStats().sizeWithAttributes(attributes).width,
                100
            )
            
            progressPoint2.getStats().drawInRect(rectForRightImageStats, withAttributes:attributes)
        }
        
        var finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}
