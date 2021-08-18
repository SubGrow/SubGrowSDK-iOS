//
//  DiscountSignature.swift
//  B2S
//
//  Created by Egor Sakhabaev on 08.07.2021.
//

import Foundation

public struct DiscountSignature: Codable {
    public let offerId: String
    public let keyId: String
    public let nonce: String
    public let sign: String
    public let timeStamp: TimeInterval
    
    private enum CodingKeys : String, CodingKey {
        case offerId   = "id"
        case keyId     = "key_identifier"
        case nonce
        case sign      = "signature"
        case timeStamp = "timestamp"
    }
}
