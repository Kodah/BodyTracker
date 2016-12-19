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
    
    class func createCompareImage(_ progressPoint1 : ProgressPoint, progressPoint2 : ProgressPoint, statsEnabled : Bool) -> UIImage
    {
        
        let image1 : UIImage = progressPoint1.getImage()!
        let image2 : UIImage = progressPoint2.getImage()!
        let size = CGSize(width: image1.size.width * 2, height: image1.size.height)
        
        let font = UIFont.systemFont(ofSize: 16)
        
        UIGraphicsBeginImageContext(size)
        
        image1.draw(in: CGRect(x: 0, y: 0, width: image1.size.width, height: image1.size.height))
        image2.draw(in: CGRect(x: image1.size.width, y: 0, width: image2.size.width, height: image2.size.height))
        
        if statsEnabled
        {
            let attributes = [
                NSFontAttributeName : font,
                NSForegroundColorAttributeName : UIColor.white,
                NSBackgroundColorAttributeName : UIColor.black.withAlphaComponent(0.5)
            ]
            
            let rectForLeftImageStats = CGRect(
                x: 10,
                y: image1.size.height - 100,
                width: progressPoint1.getStats().size(attributes: attributes).width,
                height: 100
            
            )
            
            
            progressPoint1.getStats().draw(in: rectForLeftImageStats, withAttributes: attributes)
            
            let rectForRightImageStats = CGRect(
                x: image2.size.width + 10,
                y: image2.size.height - 100,
                width: progressPoint2.getStats().size(attributes: attributes).width,
                height: 100
            )
            
            progressPoint2.getStats().draw(in: rectForRightImageStats, withAttributes:attributes)
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
}
