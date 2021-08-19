//
//  B2S.swift
//  B2S
//
//  Created by Egor Sakhabaev on 05.07.2021.
//

import Foundation
import StoreKit

public struct B2S {
    internal static var deviceId: String {
        if let deviceUDID = Keychain.getPasscode(identifier: KeychainStoredData.deviceUDID.rawValue) {
            return deviceUDID
        } else {
            let deviceUDID = UUID().uuidString
            Keychain.setPasscode(identifier: KeychainStoredData.deviceUDID.rawValue, passcode: deviceUDID)
            return deviceUDID
        }
    }
    internal static var sdkKey: String!
    internal static var pendingOffer: Offer?
    public static var delegate: B2SDelegate?
    
    public static func configure(sdkKey: String, delegate: B2SDelegate? = nil) {
        guard self.sdkKey == nil else { return }
        self.sdkKey = sdkKey
        self.delegate = delegate
        _ = IAPHandler.shared
        
        B2SService.getOffer()
            .then { offer in
                if delegate?.b2sShouldDisplayPromotionOfferScreen?() != false {
                    showPendingPromotionOfferScreen()
                } else {
                    pendingOffer = offer
                }
            }
    }
    
    public static func setPushToken(_ pushToken: Data) {
        let tokenParts = pushToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        B2SService.setPushToken(token)
    }
    
    /**
     Returns `true` if there is pending promotion offer screen.
     Manually present promotion offer screen that was delayed for presentation, i.e. `false` was returned in `b2sShouldDisplayPromotionOfferScreen` delegate method.
     */
    @discardableResult
    public static func showPendingPromotionOfferScreen() -> Bool {
        guard let offer = pendingOffer else {
            return false
        }
        let vc = FirstOfferConfigurator.createModule(with: offer)
        UIApplication.topViewController()?.present(vc, animated: true)
        return true
    }
}