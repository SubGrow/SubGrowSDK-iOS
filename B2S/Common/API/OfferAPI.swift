//
//  B2SAPI.swift
//  B2S
//
//  Created by Egor Sakhabaev on 05.07.2021.
//

import Foundation

struct OfferAPI: MainAPI {
    static func getOffer(completion: ServerResult?) {
        sendRequest(type: .post, url: B2SURL.offer.screen.url, parameters: nil, headers: nil, completion: completion)
    }
    
    static func signDiscount(offerId: String, completion: ServerResult?) {
        let params = ["offerId": offerId] as [String: AnyObject]
        sendRequest(type: .post, url: B2SURL.offer.sign.url, parameters: params, headers: nil, completion: completion)
    }
}
