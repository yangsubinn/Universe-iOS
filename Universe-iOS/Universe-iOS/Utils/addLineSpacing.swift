//
//  addLineSpacing.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/07.
//

import UIKit

extension UILabel {
    func addLineSpacing(spacing: CGFloat) {
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = spacing
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
}
