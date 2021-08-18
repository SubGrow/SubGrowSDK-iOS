//
//  B2SService.swift
//  B2S
//
//  Created by Egor Sakhabaev on 10.07.2021.
//

import Foundation

struct B2SService {
    static func getOffer() -> Promise<Offer> {
        return .init { fulfill, reject in
            OfferAPI.getOffer { response in
                switch response {
                case .Success(let responseData):
                    guard let data = try? JSONSerialization.data(withJSONObject: responseData, options: []),
                          let offer = try? JSONDecoder().decode(Offer.self, from: data) else {
                        reject(InternalError.unknownError)
                        return
                    }
                    fulfill(offer)
                case .Error(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func setPushToken(_ token: String) {
        UserAPI.setPushToken(token, completion: nil)
    }
}
