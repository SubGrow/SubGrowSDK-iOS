//
//  B2S.swift
//  B2S
//
//  Created by Egor Sakhabaev on 05.07.2021.
//

import Foundation
import StoreKit

final public class B2S {
    public static let shared = B2S()
    
    internal static var deviceId: String {
        if let deviceUDID = Keychain.getPasscode(identifier: KeychainStoredData.deviceUDID.rawValue) {
            return deviceUDID
        } else {
            let deviceUDID = UUID().uuidString
            Keychain.setPasscode(identifier: KeychainStoredData.deviceUDID.rawValue, passcode: deviceUDID)
            return deviceUDID
        }
    }
    internal var sdkKey: String!
    internal var pendingOffer: Offer?
    public var delegate: B2SDelegate?
    
    /**
     Initializes B2S SDK. Call it during app launch.
     - parameter sdkKey: Required. Your app's SDK key.
     - parameter delegate: Optional. Any B2SDelegate conformable object. You will be able to set it later
     */
    @objc
    public func configure(sdkKey: String, delegate: B2SDelegate? = nil) {
        guard self.sdkKey == nil else { return }
        self.sdkKey = sdkKey
        self.delegate = delegate
        _ = IAPHandler.shared
        
        B2SService.getOffer()
            .then { [weak self] offer in
                self?.pendingOffer = offer
                if self?.delegate?.b2sShouldDisplayPromotionOfferScreen?() != false {
                    self?.showPendingPromotionOfferScreen()
                }
            }
    }
    
    /**
     Set device push token.
     - parameter token: Push token in Data class.
    */
    @objc
    public func setPushToken(_ pushToken: Data) {
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
    @objc
    public func showPendingPromotionOfferScreen() -> Bool {
        guard let offer = pendingOffer else {
            return false
        }
        pendingOffer = nil
        let vc = FirstOfferConfigurator.createModule(with: offer)
        UIApplication.topViewController()?.present(vc, animated: true)
        return true
    }
}
