//
//  Screen.swift
//  B2S
//
//  Created by Egor Sakhabaev on 12.07.2021.
//

import Foundation

struct Screen: Codable {
    let title: TextData
    let subtitle: TextData
    let footer: String?
    let offer: TextData
    let promotionButton: ButtonData
    let language: String
    var image: ImageData?
    let backgroundColor: String?
    var backgroundImage: ImageData?
    
    private enum CodingKeys : String, CodingKey {
        case title
        case subtitle
        case footer
        case offer
        case promotionButton = "promotion_button"
        case language        = "lang"
        case image
        case backgroundColor
        case backgroundImage
    }
}
