//
//  LogoutCVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/04.
//

import UIKit
import UniverseKit
import SnapKit

class LogoutCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    
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
        self.titleLabel.font = .mediumFont(ofSize: 14)
        self.titleLabel.textColor = .mainBlue
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().inset(12)
        }
    }
}
