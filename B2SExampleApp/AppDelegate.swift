//
//  AppDelegate.swift
//  B2SDemo
//
//  Created by Egor Sakhabaev on 09.07.2021.
//

import UIKit
import B2S
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = MainConfigurator.createModule()
        registerForPushNotifications()
        SwiftyStoreKit.completeTransactions(atomically: true) { _ in }
        B2S.shared.configure(sdkKey: "7ea57fec-ed9d-4fb9-8f24-51947fe25066")
        
        return true
    }
}

// MARK: - Remote Notifications
extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        B2S.shared.setPushToken(deviceToken)
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
}


