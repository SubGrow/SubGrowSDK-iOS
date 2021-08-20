//
//  MainAPI.swift
//  DealApp
//
//  Created by Egor Sakhabaev on 23.04.2018.
//  Copyright © 2018 Egor Sakhabaev. All rights reserved.
//
import Foundation

protocol MainAPI {
    static func sendRequest(type: HTTPMethod, url: String, baseURL: String, parameters: [String: AnyObject]?, headers: [String: String]?, completion: ServerResult?)
}

extension MainAPI {
    static func sendRequest(type: HTTPMethod, url: String, baseURL: String = B2SURL.api.url, parameters: [String: AnyObject]?, headers: [String: String]?, completion: ServerResult?) {
        let params = (parameters ?? [:]).merging(defaultParams, uniquingKeysWith: { $1 })
        let header: [String: String] = (headers ?? [:]).merging(defaultHeaders, uniquingKeysWith: { $1 })
        guard let url = URL(string: baseURL + url) else { return }
        var request = URLRequest(url: url, timeoutInterval: .init(12))
        request.httpMethod = type.rawValue
        request.allHTTPHeaderFields = header
        request.httpBody = params.jsonString?.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], error == nil else {
                completion?(.Error(error: error ?? InternalError.unknownError))
                return
            }
            completion?(.Success(response: responseData))
        }.resume()
    }
}
// MARK: - Private methods
extension MainAPI {
    private static var defaultParams: [String: AnyObject] {
        let params = [
            "sdkKey": B2S.shared.sdkKey,
            "deviceId": B2S.deviceId
            ] as [String: AnyObject]
        return params
    }
    
    private static var defaultHeaders: [String: String] {
        let headers: [String: String] = ["Accept": "application/json",
                                         "Content-Type": "application/json"]

        return headers
    }
}
