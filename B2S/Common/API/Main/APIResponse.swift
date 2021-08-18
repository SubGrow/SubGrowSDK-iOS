//
//  MainAPI.swift
//  DealApp
//
//  Created by Egor Sakhabaev on 23.04.2018.
//  Copyright © 2018 Egor Sakhabaev. All rights reserved.
//
import Foundation
import Marshal

enum APIResponse {
    case Success (response: Response)
    case Error (error: Error)
}

typealias ServerResult = (_ response: APIResponse) -> Void

enum ResponseError: Error {
    case with(code: Int?, message: String?)
    case grpcFinished
    case timeout
    case unknownError
}

struct Response: Unmarshaling {
    var status: Bool?
    var responseData: Any?
    var pagination: [String: Any]?
    
    init(object: MarshaledObject) throws {
        status       = try? object.value(for: "success")
        responseData = (try? object.any(for: "data")) ?? (try? object.any(for: "response"))
        pagination   = try? object.value(for: "meta")
    }
}

// MARK: - Status
extension Response {
    struct Status: Unmarshaling {
        let code: Int
        let message: String?
        
        init(object: MarshaledObject) throws {
            code = try object.value(for: "code")
            message = try? object.value(for: "message")
        }
    }
}
