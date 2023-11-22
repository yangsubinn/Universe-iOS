//
//  badgeCell.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/03.
//

import UIKit
import UniverseKit
import SnapKit

class BadgeCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let badgeStackView = UIStackView()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setStackView()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    public func setData(_ badgeList: [BadgeModel]) {
        badgeStackView.removeAllFromSuperview()
        badgeList.forEach {
            if !$0.isEquipped { return }
            let badgeView = BadgeView($0)
            self.badgeStackView.addArrangedSubview(badgeView)
        }
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .lightGray200
        self.layer.cornerRadius = 5
        
        self.titleLabel.text = "MY 뱃지"
        self.titleLabel.textColor = .black
        self.titleLabel.font = .mediumFont(ofSize: 14)
    }
    
    private func setStackView() {
        self.badgeStackView.axis = .horizontal
        self.badgeStackView.distribution = .fill
        self.badgeStackView.spacing = 15
        self.badgeStackView.alignment = .trailing
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel, badgeStackView])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        badgeStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
