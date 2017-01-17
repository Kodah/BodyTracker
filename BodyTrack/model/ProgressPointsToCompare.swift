//
//  ProgressPointsToCompare.swift
//  BodyTrack
//
//  Created by lord on 17/01/2017.
//  Copyright © 2017 Tom Sugarex. All rights reserved.
//

import Foundation

struct ProgressPointsToCompare {
    let firstProgressPoint: ProgressPoint
    let secondProgressPoint: ProgressPoint
    
    init(firstProgressPoint: ProgressPoint, secondProgressPoint: ProgressPoint) {
        if firstProgressPoint.date?.compare(secondProgressPoint.date as! Date) == ComparisonResult.orderedAscending {
            self.firstProgressPoint = firstProgressPoint
            self.secondProgressPoint = secondProgressPoint
        } else {
            self.firstProgressPoint = secondProgressPoint
            self.secondProgressPoint = firstProgressPoint
        }
    }
}
