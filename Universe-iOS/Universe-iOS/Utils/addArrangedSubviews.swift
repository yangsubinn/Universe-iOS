//
//  addArrangedSubviews.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/03.
//

import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
