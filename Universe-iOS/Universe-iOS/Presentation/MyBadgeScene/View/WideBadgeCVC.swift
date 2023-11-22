//
//  WideBadgeCVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/04.
//

import UIKit
import UniverseKit

class WideBadgeCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let badgeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subLabel = UILabel()
    private let pinButton = UIButton()
    
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
        titleLabel.text = nil
        subLabel.text = nil
        badgeImageView.image = nil
        pinButton.isHidden = true
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.layer.cornerRadius = 5
        self.backgroundColor = .white
        self.addShadow()
        
        self.titleLabel.font = .semiBoldFont(ofSize: 16)
        self.titleLabel.textColor = .black
        
        self.subLabel.font = .regularFont(ofSize: 10)
        self.subLabel.textColor = .gray100
        self.subLabel.numberOfLines = 0
    }
    
    private func setLayout() {
        self.addSubviews([badgeImageView, titleLabel,
                          subLabel, pinButton])
        
        badgeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(27)
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(badgeImageView.snp.trailing).offset(27)
            make.top.equalToSuperview().inset(19)
            make.width.equalTo(184)
        }
        
        subLabel.snp.makeConstraints { make in
            make.leading.equalTo(badgeImageView.snp.trailing).offset(27)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        pinButton.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(11)
            make.width.height.equalTo(18)
        }
    }
    
    // MARK: - Methods
    
    func setData(_ data: BadgeModel) {
        self.titleLabel.text = data.name
        self.subLabel.text = data.description
        self.badgeImageView.updateServerImage(data.imageURL)
        
        if data.isEquipped {
            self.pinButton.setImage(Icon.icPin.image, for: .normal)
        } else if data.isIssued {
            self.pinButton.setImage(Icon.icPinInactive.image, for: .normal)
        } else {
            self.pinButton.isHidden = true
        }
    }
}
