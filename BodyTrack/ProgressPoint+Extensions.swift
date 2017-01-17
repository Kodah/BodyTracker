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

enum ProgressPointError: Error {
    case failedToSafeImage
    case failedToInitialise
}

extension ProgressPoint {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    convenience init?(builder: ProgressPointBuilder, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "ProgressPoint", in: context)!
        
        self.init(entity: entity, insertInto: context )

        if let
            image = builder.image,
            let date = builder.date,
            let fileName = builder.fileName,
            let identifier = builder.identifier,
            let progressCollection = builder.progressCollection,
            let filePath = builder.filePathToWrite {
            
            do {
                try save(image: image, toDiskAt: filePath)
                self.date = date as NSDate?
                self.imageName = fileName
                self.identifier = identifier
                self.progressCollection = progressCollection
                
            } catch let err {
                print(err)
                return nil
            }
        } else {
            return nil
        }
    }
    
    func save(image: UIImage, toDiskAt filePath: String) throws {
        
        let fileManager = FileManager.default
        let imageData: Data = UIImagePNGRepresentation(image)!
        guard fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil) else {
            throw ProgressPointError.failedToSafeImage
        }
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
