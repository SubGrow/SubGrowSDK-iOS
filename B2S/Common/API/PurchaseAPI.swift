//
//  PurchaseAPI.swift
//  B2S
//
//  Created by Egor Sakhabaev on 05.07.2021.
//

import Foundation

struct PurchaseAPI: MainAPI {
    static func sendPurchase(transactionId: String, completion: ServerResult?) {
        let params = ["originalTransactionId": transactionId] as [String: AnyObject]
        sendRequest(type: .post, url: B2SURL.purchase.root.url, parameters: params, headers: nil, completion: completion)
    }
}
