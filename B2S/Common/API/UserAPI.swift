//
//  DeviceAPI.swift
//  B2S
//
//  Created by Egor Sakhabaev on 12.07.2021.
//

import Foundation

struct UserAPI: MainAPI {
    static func setPushToken(_ token: String, completion: ServerResult?) {
        let params = ["applePushToken": token] as [String: AnyObject]
        sendRequest(type: .post, url: B2SURL.user.pushToken.url, parameters: params, headers: nil, completion: completion)
    }
}
