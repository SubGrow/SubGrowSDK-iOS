//
//  DeviceAPI.swift
//  B2S
//
//  Created by Egor Sakhabaev on 12.07.2021.
//

import Foundation

struct UserAPI: MainAPI {
    static func setPushToken(_ token: String, countryCode: String? = nil, completion: ServerResult?) {
        var params = ["applePushToken": token] as [String: AnyObject]
        if let countryCode = countryCode {
            params["countryCode"] = countryCode as AnyObject
        }
        sendRequest(type: .post, url: B2SURL.user.pushToken.url, parameters: params, headers: nil, completion: completion)
    }
}
