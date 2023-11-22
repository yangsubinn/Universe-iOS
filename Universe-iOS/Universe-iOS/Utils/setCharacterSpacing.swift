//
//  setCharacterSpacing.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/03.
//

import UIKit

extension UILabel {
    func setCharacterSpacing(kernValue: CGFloat = -0.5) {
        guard let labelText = text else { return }
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length))
        
        attributedText = attributedString
    }
}

extension UITextField {
    func setCharacterSpacing(kernValue: CGFloat = -0.5) {
        guard let labelText = text else { return }
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length))
        
        attributedText = attributedString
    }
}

extension UITextView {
    func setCharacterSpacing(kernValue: CGFloat = -0.5) {
        guard let labelText = text else { return }
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}
