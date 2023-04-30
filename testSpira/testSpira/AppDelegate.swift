//
//  AppDelegate.swift
//  TestSpira
//
//  Created by Pedro Alonso Daza B on 30/04/23.
//

import UIKit
import FirebaseCore
import UserNotifications
import FirebaseMessaging
@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
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


    // For alert notifications, call the API inside the service extension:
    class NotificationService: UNNotificationServiceExtension {
      override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
          Messaging.serviceExtension()
          .exportDeliveryMetricsToBigQuery(withMessageInfo:request.content.userInfo)
      }
    }
    
    // For background notifications, call the API inside the UIApplicationDelegate or NSApplicationDelegate method:
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        Messaging.serviceExtension().exportDeliveryMetricsToBigQuery(withMessageInfo:userInfo)
    }
}

