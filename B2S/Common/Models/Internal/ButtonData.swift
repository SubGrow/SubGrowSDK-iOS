//
//  ButtonData.swift
//  B2S
//
//  Created by Egor Sakhabaev on 12.07.2021.
//

import Foundation

struct ButtonData: Codable {
    let text: String
    let textColor: String
    let backgroundColor: String
    
    private enum CodingKeys : String, CodingKey {
        case text
        case textColor          = "text_color"
        case backgroundColor    = "background_color"
    }
}
