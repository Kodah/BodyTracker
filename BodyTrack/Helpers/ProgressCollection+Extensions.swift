//
//  ProgressCollectionHelper.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 10/07/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import Foundation
import CoreData

extension ProgressCollection {
    
    static func GetFirstProgressCollectionIn(_ context: NSManagedObjectContext,
                                             _ completion: (ProgressCollection) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgressCollection")
        do {
            let progressCollectionArray: [ProgressCollection] =
                try (context.fetch(fetchRequest) as? [ProgressCollection])!
            if let firstProgressCollection = progressCollectionArray.first {
                completion(firstProgressCollection)
            }
        } catch {}
    }
    
    func latestProgressPoint() -> ProgressPoint? {
        guard let pointsArray = Array(progressPoints!) as? [ProgressPoint] else {
            return nil
        }
        return pointsArray.sorted(by: {$0.date?.compare($1.date as! Date) == ComparisonResult.orderedDescending}).first
    }
}
