//
//  NotificationFactory.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 10/07/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class NotificationFactory: NSObject {
    
    private let PROGRESS_ITEMS = "progressItems"
    
    func scheduleNotificationForProgressCollection(progressCollection:ProgressCollection)
    {
        
        var progressDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(PROGRESS_ITEMS) ?? Dictionary()
        
//        progressDictionary[progressCollection.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
//        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: PROGRESS_ITEMS)
//        
        var notification = UILocalNotification()
        notification.alertBody = "BodyTrack progress picture due for \(progressCollection.name)"
        notification.alertAction = "open"
//        notification.fireDate = item.deadline
        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func calculateNotificationFireDateFor(progressCollection : ProgressCollection) -> NSDate?
    {
        
        if let progressPoint = progressCollection.latestProgressPoint()
        {
            var components = NSDateComponents()
            let numOfWeeks = progressCollection.interval
            components.day = numOfWeeks.integerValue * 7
            
            return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: progressPoint.date, options: nil)
        }
        return nil
    }
}
