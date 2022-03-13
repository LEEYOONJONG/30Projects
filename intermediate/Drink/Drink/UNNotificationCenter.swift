//
//  UNNotificationCenter.swift
//  Drink
//
//  Created by YOONJONG on 2022/03/13.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter{
    func addNotificationRequest(by alert: Alert){
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이에요."
        content.body = "세계뽀건기구가 권장하는 물 섭취량은 2리터입니다"
        content.sound = .default
        content.badge = 1
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
    }
}
