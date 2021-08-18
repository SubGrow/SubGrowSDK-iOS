//
//  Extension+NSAttributedString.swift
//  B2S
//
//  Created by Egor Sakhabaev on 12.07.2021.
//

import UIKit

extension String {
    func htmlToString(font: UIFont = .systemFont(ofSize: 14, weight: .regular), color: UIColor = .black) -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString(string: self) }
        do {
            let attrText = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            attrText.addAttributes([.font: font, .foregroundColor: color], range: NSMakeRange(0, attrText.length))
            return attrText
        } catch {
            return NSAttributedString(string: self)
        }
    }
}
