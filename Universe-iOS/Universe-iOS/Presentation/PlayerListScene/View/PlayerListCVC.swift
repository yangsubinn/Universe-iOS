//
//  PlayerListCVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import UIKit
import UniverseKit

class PlayerListCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let disableOpacity: CGFloat = 0.3
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let ntrpLabel = UILabel()
    
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
    
    // MARK: - UI & Layout
    
    private func setUI() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 22
        profileImageView.layer.masksToBounds = true
        
        userNameLabel.textColor = .black
        userNameLabel.font = .mediumFont(ofSize: 16)
        
        ntrpLabel.textColor = .gray100
        ntrpLabel.font = .regularFont(ofSize: 10)
    }
    
    private func setLayout() {
        self.addSubviews([profileImageView, userNameLabel, ntrpLabel])
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(23)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(13)
            make.top.equalToSuperview().inset(12)
        }
        
        ntrpLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel.snp.leading)
            make.top.equalTo(userNameLabel.snp.bottom).offset(3)
        }
    }
    
    // MARK: - Methods
    
    func setData(data: PlayerModel) {
        if let profileImage = data.profileImage {
            profileImageView.updateServerImage(profileImage)
        } else {
            profileImageView.image = Icon.icProfileBlack.image
        }
        
        if let ntrp = data.ntrp {
            ntrpLabel.text = "NTRP \(ntrp)"
        }
        self.userNameLabel.text = data.userName
        
        if data.isSelected || data.isPlaying {
            self.profileImageView.alpha = disableOpacity
            self.userNameLabel.textColor = .black.withAlphaComponent(disableOpacity)
            self.ntrpLabel.textColor = .gray100.withAlphaComponent(disableOpacity)
        }
    }
}
