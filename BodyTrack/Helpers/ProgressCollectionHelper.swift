//
//  ProgressCollectionHelper.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 10/07/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import Foundation


extension ProgressCollection
{
    func latestProgressPoint() -> ProgressPoint?
    {
        let pointsArray : Array<ProgressPoint> = Array(progressPoints) as! Array<ProgressPoint>
        
        pointsArray.sorted(by: {$0.date.compare($1.date) == ComparisonResult.orderedDescending})
        
        return pointsArray.first
    }
}
