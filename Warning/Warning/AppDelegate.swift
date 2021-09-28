//
//  AppDelegate.swift
//  Warning
//
//  Created by YOONJONG on 2021/09/27.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // ** 원격알림은 시뮬레이터로 안됨.

    //delegate setting
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 초기화 함수 작성
        FirebaseApp.configure() // firebase 초기화
        
        Messaging.messaging().delegate = self // fcm에 현재 등록 토큰이나 갱신되는 시점 알고 적절한 액션을 취할 수 있음
        
        // FCM 현재 등록 토큰 확인
        Messaging.messaging().token { token, error in
            if let error = error {
                print("ERROR FCM 등록토큰 가져오기 : \(error.localizedDescription)")
            } else if let token = token {
                print("FCM 등록토큰 : \(token)")
            }
        }
        
        // noti 승인 받을 수 있도록
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, error in
            print("ERROR, Request Notifications Authorization: \(error.debugDescription)")
        }
        application.registerForRemoteNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// 우리는 모두 사운드, 뱃지 등 모두 뜨게 할것
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .badge, .sound])
    }
}

extension AppDelegate: MessagingDelegate{
    // 토큰이 갱신되는 시점. 다시 토큰 받았는지 확인이 가능
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("FCM 등록토큰 갱신 : \(token)")
    }
}
