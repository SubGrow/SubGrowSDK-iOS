//
//  B2SURL.swift
//  B2S
//
//  Created by Egor Sakhabaev on 05.07.2021.
//

import Foundation

enum B2SURL: String, Host {
    var host: String {
        return "https://return.bogunov.co.jp"
    }
    case root = ""
    case api = "/api"
}

extension B2SURL {
    enum offer: String, Endpoint {
        var path: String {
            "/offer"
        }
        case root   = ""
        case screen = "/screen"
        case sign   = "/sign"
    }
    
    enum purchase: String, Endpoint {
        var path: String {
            "/purchase"
        }
        case root   = ""
    }

    enum user: String, Endpoint {
        var path: String {
            "/app-user"
        }
        case root   = ""
        case pushToken  = "/token"
    }

}
