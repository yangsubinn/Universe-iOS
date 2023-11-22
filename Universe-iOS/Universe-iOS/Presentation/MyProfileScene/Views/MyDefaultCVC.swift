//
//  MyDefaultCVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/04.
//

import UIKit
import UniverseKit
import SnapKit

class MyDefaultCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    public func setData(_ title: String) {
        self.titleLabel.text = title
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.titleLabel.font = .mediumFont(ofSize: 16)
        self.titleLabel.textColor = .black
        self.arrowImageView.image = Icon.icEnter.image
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel, arrowImageView])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().inset(12)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
}
