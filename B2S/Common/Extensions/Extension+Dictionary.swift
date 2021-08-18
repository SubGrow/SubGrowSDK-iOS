//
//  Extension+Dictionary.swift
//  B2S
//
//  Created by Egor Sakhabaev on 05.07.2021.
//

import Foundation

extension Dictionary {
    var jsonString: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: []) else {
            return nil
        }
        
        return String(data: theJSONData, encoding: .ascii)
    }
}
