//
//  ProgressPointHelper.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 19/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ProgressPoint {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func getImage(_ quality: JPEGQuality = .highest) -> UIImage? {
        let fileManager = FileManager.default
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        let fullPath = documentsDirectory.appendingPathComponent(imageName!)

        if fileManager.fileExists(atPath: fullPath.path) {
            if let imageis: UIImage = UIImage(contentsOfFile: fullPath.path),
                let imageData = UIImageJPEGRepresentation(imageis, quality.rawValue) {
                return UIImage(data: imageData)
            }
        }
        return nil
    }
    
    open override var description: String {
        var description = ""
        
        if let date = date {
            description += "Date: \(date) \n"
        }
        if let measurement = measurement {
            description += "Measurement: \(measurement)cm \n"
        }
        if let weight = weight {
            description += "Weight: \(weight)kg \n"
        }
        if let bodyFat = bodyFat {
            description += "Body fat: \(bodyFat)% \n"
        }
        
        return description
    }
    
    func delete(from context: NSManagedObjectContext) {
        deleteProgressPointImageFromDisk()
        context.delete(self)
        do {
            try context.save()
        } catch {}
    }
    
    private func deleteProgressPointImageFromDisk() {
        let fileManager = FileManager.default
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        let fullPath = documentsDirectory.appendingPathComponent(imageName!)

        do {
            try fileManager.removeItem(atPath: fullPath.path)
        } catch {
            print("failed to delete image for progress point")
        }
    }
        
}
