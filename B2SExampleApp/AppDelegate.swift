//
//  AppDelegate.swift
//  B2SDemo
//
//  Created by Egor Sakhabaev on 09.07.2021.
//

import UIKit
import B2S
import SwiftyStoreKit
import StoreKit

// old
//let productIds: [String] = ["com.b2s.subscription.freemonth",
//                            "com.b2s.subscription.oneMonth",
//                            "com.b2s.subscription.threemonth",
//                            "com.b2s.subscription.sixmonth",
//                            "com.b2s.subscription.oneYear"]

let productIds: [String] = ["com.subgrow.subscription.freemonth",
                            "com.subgrow.subscription.onemonth",
                            "com.subgrow.subscription.threemonth",
                            "com.subgrow.subscription.sixmonth",
                            "com.subgrow.subscription.oneyear"]


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = MainConfigurator.createModule()
        B2S.shared.configure(sdkKey: "7ea57fec-ed9d-4fb9-8f24-51947fe25066",
                             delegate: nil)
        TimeService.enableAutoSync()
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        registerForPushNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let code: String? = {
            if let storeFront = SKPaymentQueue.default().storefront {
                return storeFront.countryCode
            }
            return nil
        }()
        B2S.shared.setPushToken(deviceToken, countryCode: code)
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


