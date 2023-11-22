//
//  removeAllFromSuperview.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/25.
//

import UIKit

extension UIStackView {
    func removeAllFromSuperview() {
        self.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
