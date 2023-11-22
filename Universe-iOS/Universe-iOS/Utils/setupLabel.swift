//
//  setupLabel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/03.
//

import UIKit

extension UILabel {
    func setupLabel(text: String,
                    color: UIColor,
                    font: UIFont,
                    align: NSTextAlignment? = .left) {
        self.font = font
        self.text = text
        self.textColor = color
        self.textAlignment = align ?? .left
    }
}
