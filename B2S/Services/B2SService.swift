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
                    prepareOffer(offer)
                        .then { preparedOffer in
                            fulfill(preparedOffer)
                        }
                case .Error(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func prepareOffer(_ offer: Offer) -> Promise<Offer> {
        let group = DispatchGroup()
        var preparedOffer = offer
        if let backgroundImageURL = URL(string: preparedOffer.screenData.backgroundImage?.url ?? "") {
            group.enter()
            downloadImage(url: backgroundImageURL)
                .then { data in
                    preparedOffer.screenData.backgroundImage?.data = data
                    group.leave()
                }
                .catch { _ in
                    group.leave()
                }
        }
        if let iconImageURL = URL(string: preparedOffer.screenData.image?.url ?? "") {
            group.enter()
            downloadImage(url: iconImageURL)
                .then { data in
                    preparedOffer.screenData.image?.data = data
                    group.leave()
                }
                .catch { _ in
                    group.leave()
                }
        }
        return Promise { fulfill, reject in
            group.notify(queue: .main) {
                fulfill(preparedOffer)
            }
        }
    }
    
    static func setPushToken(_ token: String) {
        UserAPI.setPushToken(token, completion: nil)
    }
}

func downloadImage(url: URL) -> Promise<Data> {
    return Promise(queue: DispatchQueue.global()) { fulfill, reject in
        guard let data = try? Data(contentsOf: url) else {
            reject(InternalError.unknownError)
            return
        }
        fulfill(data)
    }
}
