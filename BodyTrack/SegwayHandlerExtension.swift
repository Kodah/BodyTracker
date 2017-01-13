//
//  SegwayHandlerExtension.swift
//  BodyTrack
//
//  Created by lord on 13/01/2017.
//  Copyright © 2017 Tom Sugarex. All rights reserved.
//

import Foundation
import UIKit

public protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

public extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    
    public func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    public func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Couldn't handle segue identifier \(segue.identifier) for view controller of type \(type(of: self)).")
        }
        
        return segueIdentifier
    }
}
