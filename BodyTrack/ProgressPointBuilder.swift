//
//  ProgressPointBuillder.swift
//  BodyTrack
//
//  Created by lord on 17/01/2017.
//  Copyright © 2017 Tom Sugarex. All rights reserved.
//

import Foundation
import UIKit

class ProgressPointBuilder {
    
    var date: Date?
    var fileName: String?
    var identifier: String?
    var progressCollection: ProgressCollection?
    var image: UIImage?
    var filePathToWrite: String?
    
    typealias BuilderClosure = (ProgressPointBuilder) -> Void
    
    init(buildClosure: BuilderClosure) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)[0]
        date = Date()
        identifier = UUID().uuidString
        fileName = "\(identifier!).png"
        filePathToWrite = "\(paths)/\(fileName!)"
        
        buildClosure(self)
    }
    
}
