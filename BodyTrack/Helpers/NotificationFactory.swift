//
//  NotificationFactory.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 10/07/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class NotificationFactory: NSObject {

    func scheduleNotificationForProgressCollection(_ progressCollection: ProgressCollection) {
        let application = UIApplication.shared

        if !notificationEnabled() {
            if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
                application.registerUserNotificationSettings(UIUserNotificationSettings(
                    types: [.alert, .badge, .sound],
                    categories: nil)
                )
            }
            if notificationEnabled() {
                createNotification(progressCollection)
            }
        } else {
            createNotification(progressCollection)
        }

    }

    func createNotification(_ progressCollection: ProgressCollection) {
        let PROGRESS_ITEMS = "progressItems"

        var progressDictionary = UserDefaults.standard.dictionary(forKey: PROGRESS_ITEMS) ?? Dictionary()

        if let reminderDate = calculateNotificationFireDateFor(progressCollection),
            let id = progressCollection.identifier {
            if reminderDate.compare(Date()) == ComparisonResult.orderedDescending {
                progressDictionary[id] = ["deadline": reminderDate,
                                                                     "title": progressCollection.name!]

                let notification = UILocalNotification()
                notification.alertBody = "BodyTrack progress picture due for \(progressCollection.name!)"
                notification.alertAction = "open"
                notification.fireDate = reminderDate
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.userInfo = ["UUID": id]
                notification.category = "PROGRESS_CATEGORY"
                UIApplication.shared.scheduleLocalNotification(notification)
            } else {
                _ = progressDictionary.removeValue(forKey: id)
                deleteNotificationWith(id)

            }
            UserDefaults.standard.set(progressDictionary, forKey: PROGRESS_ITEMS)

        }
    }

    func deleteNotificationWith(_ UUIDToDelete: String) {
        let app: UIApplication = UIApplication.shared
        for oneEvent in app.scheduledLocalNotifications! {
            let notification = oneEvent
            if let userInfoCurrent = notification.userInfo! as? [String:AnyObject],
                let uid = userInfoCurrent["UUID"]! as? String {
                if uid == UUIDToDelete {
                    app.cancelLocalNotification(notification)
                    break
                }
            }
        }
    }

    func calculateNotificationFireDateFor(_ progressCollection: ProgressCollection) -> Date? {
        if let progressPoint = progressCollection.latestProgressPoint() {
            var components = DateComponents()
            if let numOfWeeks = progressCollection.interval {

                components.day = numOfWeeks.intValue * 7
            }

            return NSCalendar.current.date(byAdding: components, to: progressPoint.date as! Date)
        }
        return nil
    }

    func notificationEnabled() -> Bool {
        let settings = UIApplication.shared.currentUserNotificationSettings
        return settings!.types != []
    }
}
