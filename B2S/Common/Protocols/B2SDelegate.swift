//
//  B2SDelegate.swift
//  B2S
//
//  Created by Egor Sakhabaev on 18.08.2021.
//

import Foundation
import StoreKit

@objc public protocol B2SDelegate {
    /**
     You can return `false` to this delegate method if you want to delay promotion offer screen presentation.
     
     You will be able to display this screen manually via call B2S.showPendingPromotionOfferScreen() method.
     */
    @objc optional func b2sShouldDisplayPromotionOfferScreen() -> Bool
    
    /**
     Called when user tapped on purchase button in promotion offer screen.
     */
    @objc optional func b2sPromotionOfferWillPurchase(productId: String, offerId: String)
    
    /**
     Called when successfully purchased promotion offer.
     */
    @objc optional func b2sPromotionOfferDidPurchase(productId: String, offerId: String)
    
    /**
     Called when purchase failed in promotion offer screen.
     */
    @objc optional func b2sPromotionOfferDidFailPurchase(productId: String, offerId: String, errorCode: SKError.Code)
    
    /**
     Called after the screen has appeared
     */
    @objc optional func b2sScreenDidAppear()
    
    /**
     Called before screen will be dismissed.
     */
    @objc optional func b2sScreenWillDismiss()
    
    /**
     Called after screen has been dismissed.
     */
    @objc optional func b2sScreenDidDismiss()
}
