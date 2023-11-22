//
//  setAttributedText.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/03.
//

import UIKit
import UniverseKit

extension UILabel {
    func setTargetAttributedText(targetString: String, fontType: UIFont.Weight, fontSize: CGFloat? = nil, color: UIColor? = nil, text: String? = nil, lineHeightMultiple: CGFloat? = nil) {
        
        let fontSize = fontSize ?? self.font.pointSize
        
        var font: UIFont!
        switch fontType {
        case .regular:
            font = .regularFont(ofSize: fontSize)
        case .medium:
            font = .mediumFont(ofSize: fontSize)
        case .semibold:
            font = .semiBoldFont(ofSize: fontSize)
        case .bold:
            font = .boldFont(ofSize: fontSize)
        default:
            font = .mediumFont(ofSize: fontSize)
        }
        
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = lineHeightMultiple ?? 0
            
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: (text as NSString).range(of: text))
        }
        
        attributedString.addAttribute(.font, value: font as Any, range: range)
        
        if let textColor = color {
            attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        }
        
        self.attributedText = attributedString
        
    }
    
    func setTargetAttrubutedTexts(targetStrings: [String], fontType: UIFont.Weight, fontSize: CGFloat? = nil, color: UIColor? = nil, text: String? = nil, lineHeightMultiple: CGFloat? = nil) {
        
        let fontSize = fontSize ?? self.font.pointSize
        
        var font: UIFont!
        switch fontType {
        case .regular:
            font = .regularFont(ofSize: fontSize)
        case .medium:
            font = .mediumFont(ofSize: fontSize)
        case .semibold:
            font = .semiBoldFont(ofSize: fontSize)
        case .bold:
            font = .boldFont(ofSize: fontSize)
        default:
            font = .mediumFont(ofSize: fontSize)
        }
        let fullText = self.text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = lineHeightMultiple ?? 0
            
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: (text as NSString).range(of: text))
        }
        
        for i in 0...targetStrings.count-1 {
            let range = (fullText as NSString).range(of: targetStrings[i])
            attributedString.addAttribute(.font, value: font as Any, range: range)
        }
        
        self.attributedText = attributedString
    }
}
