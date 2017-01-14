//
//  ProgressPointCollectionViewCell.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 18/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

struct AnimationValues {
    var fromValue = 1
    var toValue = 12
    var duration = 0.1
}

extension CABasicAnimation {
    
    convenience init(with animationValues: AnimationValues) {
        self.init(keyPath: "borderWidth")
        self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.fromValue = animationValues.fromValue
        self.toValue = animationValues.toValue
        self.duration = animationValues.duration
        self.isRemovedOnCompletion = false
        self.fillMode = kCAFillModeForwards
    }
}

class ProgressPointCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var progressPicImageView: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    let borderRadiusSelected = 6
    let borderRadiusNotSelected = 1
    let borderRaduisBeingSelected = 12
    
    let animationValuesForSelectingStart = AnimationValues(fromValue: 1, toValue: 12, duration: 0.2)
    let animationValuesForSelectingEnd = AnimationValues(fromValue: 12, toValue: 6, duration: 0.3)
    
    let animationValuesForDeselectingStart = AnimationValues(fromValue: 6, toValue: 12, duration: 0.1)
    let animationValuesForDeselectingEnd = AnimationValues(fromValue: 12, toValue: 1, duration: 0.3)
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                
                layer.add(CABasicAnimation(with: animationValuesForSelectingStart), forKey: "borderWidth")
                layer.add(CABasicAnimation(with: animationValuesForSelectingEnd), forKey: "borderWidth")
                
            } else {
                layer.add(CABasicAnimation(with: animationValuesForDeselectingEnd), forKey: "borderWidth")
                layer.add(CABasicAnimation(with: animationValuesForDeselectingEnd), forKey: "borderWidth")
            }
        }
    }
}
