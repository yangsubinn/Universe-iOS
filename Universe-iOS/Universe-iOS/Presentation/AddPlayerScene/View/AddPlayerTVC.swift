//
//  AddPlayerTVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import UIKit
import UniverseKit

class AddPlayerTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let ntrpLabel = UILabel()
    
    // MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.image = nil
        self.userNameLabel.text = nil
        self.ntrpLabel.text = nil
        self.userNameLabel.textColor = .black
        self.userNameLabel.font = .mediumFont(ofSize: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 11, right: 0))
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.selectionStyle = .none
        
        profileImageView.layer.cornerRadius = 22
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        
        userNameLabel.textColor = .black
        userNameLabel.font = .mediumFont(ofSize: 16)
        
        ntrpLabel.textColor = .gray100
        ntrpLabel.font = .regularFont(ofSize: 14)
    }
    
    private func setLayout() {
        self.addSubviews([profileImageView, userNameLabel, ntrpLabel])
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(23)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
        
        ntrpLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(28)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Method
    
    func setData(data: PlayerModel, isMe: Bool) {
        if let profileImage = data.profileImage {
            self.profileImageView.updateServerImage(profileImage)
        } else {
            self.profileImageView.image = Icon.icProfileBlack.image
        }
        
        if let ntrp = data.ntrp {
            self.ntrpLabel.text = "NTRP \(ntrp)"
        }
        
        if isMe {
            self.userNameLabel.font = .semiBoldFont(ofSize: 16)
            self.userNameLabel.text = "\(data.userName) (나)"
        } else {
            self.userNameLabel.text = data.userName
        }
    }
    
    func setDuplicatedUI() {
        self.userNameLabel.textColor = .subOrange
    }
}
