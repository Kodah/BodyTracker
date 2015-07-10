//
//  NotificationFactory.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 10/07/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class NotificationFactory: NSObject {
    
    func scheduleNotificationForProgressCollection(progressCollection:ProgressCollection)
    {
        var application = UIApplication.sharedApplication()
        
        if !notificationEnabled()
        {
            if application.respondsToSelector("registerUserNotificationSettings:")
            {
                application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
            }
            if notificationEnabled()
            {
                createNotification(progressCollection)
            }
        }
        else
        {
            createNotification(progressCollection)
        }

    }
    
    func createNotification(progressCollection : ProgressCollection)
    {
        let PROGRESS_ITEMS = "progressItems"
        
        var progressDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(PROGRESS_ITEMS) ?? Dictionary()
        
        if let reminderDate = calculateNotificationFireDateFor(progressCollection)
        {
            progressDictionary[progressCollection.identifier] = ["deadline": reminderDate, "title": progressCollection.name]
            
            NSUserDefaults.standardUserDefaults().setObject(progressDictionary, forKey: PROGRESS_ITEMS)
            
            var notification = UILocalNotification()
            notification.alertBody = "BodyTrack progress picture due for \(progressCollection.name)"
            notification.alertAction = "open"
            notification.fireDate = reminderDate
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["UUID": progressCollection.identifier]
            notification.category = "PROGRESS_CATEGORY"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
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
    
    
    func notificationEnabled() ->Bool
    {
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        return settings.types != UIUserNotificationType.None
    }
}
