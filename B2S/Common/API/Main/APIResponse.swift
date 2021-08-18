//
//  MainAPI.swift
//  DealApp
//
//  Created by Egor Sakhabaev on 23.04.2018.
//  Copyright © 2018 Egor Sakhabaev. All rights reserved.
//
import Foundation

enum APIResponse {
    case Success (response: [String: Any])
    case Error (error: Error)
}

typealias ServerResult = (_ response: APIResponse) -> Void

enum ResponseError: Error {
    case with(code: Int?, message: String?)
    case grpcFinished
    case timeout
    case unknownError
}

