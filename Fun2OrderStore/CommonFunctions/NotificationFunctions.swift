//
//  NotificationFunctions.swift
//  Fun2OrderStore
//
//  Created by Lo Fang Chou on 2020/9/17.
//

import Foundation
import UIKit
import SwiftUI

func getTappedNotification(notification: UNNotification, notification_function: NotificationFunctionID) {
    print("&&&&&&&&&&&&&  getTappedNotification setupNotification")
    guard let _ = notification.request.content.userInfo["orderOwnerID"] as? String,
          let _ = notification.request.content.userInfo["orderOwnerName"] as? String,
          let _ = notification.request.content.userInfo["orderOwnerToken"] as? String,
        let _ = notification.request.content.userInfo["orderNumber"] as? String,
        let notificationType = notification.request.content.userInfo["notificationType"] as? String,
        let _ = notification.request.content.userInfo["createTime"] as? String
    else {
        presentSimpleAlertMessage(title: "資料錯誤", message: "收到的通知資料格式錯誤")
        return
    }

    if !verifyNotificationType(type: notificationType) {
        presentSimpleAlertMessage(title: "資料錯誤", message: "收到的通知類別錯誤，無法處理")
        return
    }

    switch notificationType {
    case STORE_NOTIFICATION_TYPE_BRAND_MESSAGE:
        notification_function.functionID = 0
        return

        case STORE_NOTIFICATION_TYPE_NEW_ORDER:
            notification_function.functionID = 1
            return
                    
        default:
            notification_function.functionID = 0
            break
    }
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
}

func verifyNotificationType(type: String) -> Bool {
    switch type {
        case STORE_NOTIFICATION_TYPE_NEW_ORDER:
            return true
            
        case STORE_NOTIFICATION_TYPE_BRAND_MESSAGE:
            return true
                    
        default:
            return false
    }
}
