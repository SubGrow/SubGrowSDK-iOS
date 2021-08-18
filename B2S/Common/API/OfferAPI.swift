//
//  B2SAPI.swift
//  B2S
//
//  Created by Egor Sakhabaev on 05.07.2021.
//

import Foundation

struct B2SAPI: MainAPI {
    static func getOffer(completion: ServerResult?) {
        sendRequest(type: .post, url: B2SURL.offer.screen.url, parameters: nil, headers: nil, completion: completion)
    }
    
    static func sign() {
        
    }
}
