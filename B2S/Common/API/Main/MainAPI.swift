//
//  MainAPI.swift
//  DealApp
//
//  Created by Egor Sakhabaev on 23.04.2018.
//  Copyright © 2018 Egor Sakhabaev. All rights reserved.
//
import Foundation
import Alamofire

var alamofireManager: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 15
    let alamofireManager = Session(configuration: configuration)
    return alamofireManager
}()

protocol MainAPI {
    static func sendRequest(type: HTTPMethod, url: String!, baseURL: String, parameters: [String: AnyObject]?, headers: HTTPHeaders?, encoding: ParameterEncoding, completion: ServerResult?)
}

extension MainAPI {

    static func sendRequest(type: HTTPMethod, url: String!, baseURL: String = API.baseURL, parameters: [String: AnyObject]?, headers: HTTPHeaders?, encoding: ParameterEncoding = JSONEncoding(), completion: ServerResult?) {
        var urlString = baseURL + url
        var params = parameters
        var encode = encoding
        if type == .get {
            encode = URLEncoding()
        }
        if type == .delete || parameters?.count == 1 && parameters?.keys.first == "" {
            let values = parameters?.values.compactMap{$0}
            if values?.count ?? 0 > 0 {
                urlString.append("/\(values![0])")
                params = nil
            }
        }
        
        var header: HTTPHeaders = headers == nil ? HTTPHeaders() : headers!
        header["Accept"] = "application/json"
        if let token = AppSettings.accessToken {
            header["Authorization"] = "Bearer \(token)"
        }

        let tagString = "[Request] "
        print(tagString + urlString + "\r\n \(String(describing: params))")
        alamofireManager.request(urlString, method: type, parameters: params, encoding: encode ,headers: header ).responseJSON { (response) in
            switch response.result {
            case let .failure(error):
                var errorDescription = error.localizedDescription
                if error.isSessionTaskError {
                    errorDescription = AppError.noInternetConnection.localizedDescription
                }
                completion?(.Error(error: AppError.custom(code: error.responseCode ?? 0, title: "", message: errorDescription)))
            case let .success(responseData):
                if let data = try? Response(object: responseData as? [String: Any] ?? [:])  {
                    completion?( .Success (response: data))
                } else {
                    var error = AppError.unknownError
                    if let code = (responseData as? [String: Any])?["code"] as? Int, let message = (responseData as? [String: Any])?["message"] as? String {
                        error = AppError.custom(code: code, title: "", message: message)
                    }
                    completion?(.Error(error: error))
                }
            }
        }
    }
        
    static func upload(url: String!, baseURL: String = API.baseURL, images: [UIImage], imagesKey: String = "file", params: [String: String] = [:], headers: HTTPHeaders?, completion: ServerResult?) {
        let urlString = baseURL + url
        var header: HTTPHeaders = headers == nil ? HTTPHeaders() : headers!
        header["Accept"] = "application/json"
        if let token = AppSettings.accessToken {
            header["Authorization"] = "Bearer \(token)"
        }
        AF.upload(multipartFormData: { (multipartFormData) in
            for (index, image) in images.enumerated() {
                let imgData = image.jpegData(compressionQuality: 0.8)!
                multipartFormData.append(imgData, withName: imagesKey, fileName: "image\(index).jpg", mimeType: "image/jpg")
            }
            params.forEach {
                multipartFormData.append($0.value.data(using: .utf8) ?? Data(), withName: $0.key)
            }
        }, to: urlString, headers: header).responseJSON { (response) in
            switch response.result {
            case let .failure(error):
                completion?(.Error(error: AppError.custom(code: error.responseCode ?? 0, title: "", message: error.localizedDescription)))
            case let .success(responseData):
                if let data = try? Response(object: responseData as? [String: Any] ?? [:])  {
                    completion?( .Success (response: data))
                } else {
                    var error = AppError.unknownError
                    if let code = (responseData as? [String: Any])?["code"] as? Int, let message = (responseData as? [String: Any])?["message"] as? String {
                        error = AppError.custom(code: code, title: "", message: message)
                    }
                    completion?(.Error(error: error))
                }
            }
        }
    }
}

