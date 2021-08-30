//
//  Offer.swift
//  B2S
//
//  Created by Egor Sakhabaev on 10.07.2021.
//

import Foundation

struct Offer: Codable {
    let offerId: String
    let productId: String
    var screenData: Screen
    
    private enum CodingKeys : String, CodingKey {
        case offerId    = "promotionOfferId"
        case productId  = "productId"
        case screenData = "screen"
    }
}
