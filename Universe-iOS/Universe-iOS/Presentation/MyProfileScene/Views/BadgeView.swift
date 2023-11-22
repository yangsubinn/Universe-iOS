//
//  badgeView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/03.
//

import UIKit
import UniverseKit
import SnapKit

class BadgeView: UIView {
    
    // MARK: - UI Components
    
    private let badgeImageView = UIImageView()
    
    // MARK: - Initialize
    
    init(_ model: BadgeModel) {
        super.init(frame: .zero)
        self.setUI(model)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI & Layout
    
    private func setUI(_ model: BadgeModel) {
        self.backgroundColor = .white
        self.layer.cornerRadius = 26
        
        self.badgeImageView.updateServerImage(model.imageURL)
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(52)
        }
        
        self.addSubview(badgeImageView)
        
        badgeImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
            
        }
    }
}
