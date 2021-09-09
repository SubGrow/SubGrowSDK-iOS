//
//  PushNotification.swift
//  B2S
//
//  Created by Egor Sakhabaev on 09.09.2021.
//

import Foundation

struct PushNotification: Codable {
    let type: PushType
    let data: Offer?
    
    private enum CodingKeys : String, CodingKey {
        case type    = "type"
        case data    = "data"
    }
}
