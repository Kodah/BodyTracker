//
//  ProgressPointHelper.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 19/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import Foundation


extension ProgressPoint
{
    func getImage() -> UIImage?
    {
        
        
        let fileManager = FileManager.default
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
        
//        let fullPath = "\(path)/\(imageName)"
        
        let fullPath = documentsDirectory.appendingPathComponent(imageName)

        
        if (fileManager.fileExists(atPath: fullPath.path))
        {
            print("FILE AVAILABLE");
            
            //Pick Image and Use accordingly
            let imageis: UIImage = UIImage(contentsOfFile: fullPath.path)!
            
            return imageis
            
        }
        else
        {
            print("FILE NOT AVAILABLE");
            
            return nil
            
        }
    }
    
    func getStats() -> NSString
    {
        var description = ""
        
        if let date = date
        {
            description += "Date: \(date) \n"
        }
        if let measurement = measurement
        {
            description += "Measurement: \(measurement)cm \n"
        }
        if let weight = weight
        {
            description += "Weight: \(weight)kg \n"
        }
        if let bodyFat = bodyFat
        {
            description += "Body fat: \(bodyFat)% \n"
        }
        
        return description as NSString
    }
}
