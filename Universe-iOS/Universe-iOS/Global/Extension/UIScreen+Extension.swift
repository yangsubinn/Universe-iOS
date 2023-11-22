//
//  UIScreen+Extension.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import UIKit

extension UIScreen {
    public var hasNotch: Bool {
        let deviceRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        if deviceRatio > 0.5 {
            return false
        } else {
            return true
        }
    }
}
