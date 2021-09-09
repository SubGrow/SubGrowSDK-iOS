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
    public var language: String = Bundle.main.preferredLocalizations.first ?? "en"
    
    /**
     Initializes B2S SDK. Call it during app launch.
     - parameter sdkKey: Required. Your app's SDK key.
     - parameter language: Optional. Offer screen localization language. Default main Bundle.main.preferredLocalizations.first or en
     - parameter delegate: Optional. Any B2SDelegate conformable object. You will be able to set it later
     */
    @objc
    public func configure(sdkKey: String, language: String? = nil, delegate: B2SDelegate? = nil) {
        guard self.sdkKey == nil else { return }
        self.sdkKey = sdkKey
        self.delegate = delegate
        if let language = language {
            self.language = language
        }
        _ = IAPHandler.shared
        
        B2SService.getOffer()
            .then { [weak self] offer in
                self?.handleOffer(offer)
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
     Handling push notification event.
     - parameter userInfo: A dictionary that contains information related to the remote notification.
     - Returns: `true` for SDK related notifications..
     */
    @discardableResult
    @objc
    public func handleRemoteNotification(userInfo: [AnyHashable: Any]) -> Bool {
        guard let b2sDict = userInfo["b2s"] as? [String: Any] else { return false }
        guard let data = try? JSONSerialization.data(withJSONObject: b2sDict, options: []),
              let pushNotification = try? JSONDecoder().decode(PushNotification.self, from: data) else { return  true }
        
        switch pushNotification.type {
        case .offer:
            guard let offer = pushNotification.data else { return true }
            handleOffer(offer)
        }
        
        return true
    }

    /**
     Manually present promotion offer screen that was delayed for presentation, i.e. `false` was returned in `b2sShouldDisplayPromotionOfferScreen` delegate method.
     - Returns: `true` if there is pending promotion offer screen.
     */
    @discardableResult
    @objc
    public func showPendingPromotionOfferScreen() -> Bool {
        guard let offer = pendingOffer else {
            return false
        }
        let vc = FirstOfferConfigurator.createModule(with: offer)
        UIApplication.topViewController()?.present(vc, animated: true)
        return true
    }
}

// MARK: - Private methods
extension B2S {
    private func handleOffer(_ offer: Offer) {
        guard pendingOffer == nil else { return }
        pendingOffer = offer
        if delegate?.b2sShouldDisplayPromotionOfferScreen?() != false {
            showPendingPromotionOfferScreen()
        }
    }
}
