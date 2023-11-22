//
//  MoreButton.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/11.
//

import UIKit
import UniverseKit

class MoreButton: UIButton {
    
    // MARK: - Initialize

    public init(title: String, font: UIFont, tintColor: UIColor) {
        super.init(frame: .zero)
        self.setUI(title: title, font: font, tintColor: tintColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI(title: String, font: UIFont, tintColor: UIColor) {
        if #available(iOS 15, *) {
            var container = AttributeContainer()
            container.font = font
            container.foregroundColor = tintColor

            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString(title, attributes: container)
            configuration.image = Icon.icChevronRight.image
            configuration.imagePlacement = .trailing
            configuration.imagePadding = 5
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

            self.configuration = configuration
        } else {
            self.setTitle(title, for: .normal)
            self.setTitleColor(tintColor, for: .normal)
            self.setImage(Icon.icChevronRight.image, for: .normal)
            self.titleLabel?.font = font
            self.semanticContentAttribute = .forceRightToLeft
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
    }
}
