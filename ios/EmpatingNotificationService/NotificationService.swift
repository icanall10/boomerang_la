//
//  NotificationService.swift
//  EmpatingNotificationService
//
//  Created by Владимир on 21.01.2025.
//

import UserNotifications
import LiveActivityModule
import ActivityKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var liveActivityManager: LiveActivityManager?

    override func didReceive(
      _ request: UNNotificationRequest,
      withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        let bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let userInfo = bestAttemptContent?.userInfo {
            // 1. Извлечь нужные данные для Live Activity
            let data = userInfo["my_live_activity_data"] as? [String: Any]
            
            self.liveActivityManager?.startActivity(args: data, result: { _ in})
        }
    }

    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
