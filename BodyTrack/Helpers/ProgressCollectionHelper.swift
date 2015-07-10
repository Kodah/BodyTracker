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
        var pointsArray : Array<ProgressPoint> = Array(progressPoints) as! Array<ProgressPoint>
        
        pointsArray.sort({$0.date.compare($1.date) == NSComparisonResult.OrderedAscending})
        
        return pointsArray.first
    }
}