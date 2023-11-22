//
//  setLineHeight.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/05.
//

import UIKit

extension UILabel {
    func setLineHeight(lineHeightMultiple: CGFloat) {
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = lineHeightMultiple
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}

extension UITextView {
    func setLineHeight(lineHeightMultiple: CGFloat) {
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = lineHeightMultiple
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
