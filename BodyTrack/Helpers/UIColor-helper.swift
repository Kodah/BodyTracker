//
//  UIColor-helper.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 19/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import Foundation


extension UIColor
{
    class func randomColor() -> UIColor
    {
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }


    convenience init(hex: Int) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        
    }
    
    
    class func hexValuesFromUIColor(color : UIColor) -> String
    {
        if color == UIColor.whiteColor()
        {
            return "ffffff"
        }
        
        var red : CGFloat = 0
        var blue : CGFloat = 0
        var green : CGFloat = 0
        var alpha : CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var redDec = Int(red * 255)
        var greenDec = Int(green * 255)
        var blueDec = Int(blue * 255)
        
        return NSString(format: "%02X%02X%02X", redDec, greenDec, blueDec) as String
        
    }
    


}