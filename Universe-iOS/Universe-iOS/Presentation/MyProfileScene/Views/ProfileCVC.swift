//
//  ProfileCell.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/03.
//

import UIKit
import UniverseKit
import SnapKit

class ProfileCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var ntrp = ""
    private var manner = ""
    var isProflieTab: Bool = false
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    private let proTagLabel = UILabel()
    private let ntrpTagView = TagLabelView()
    private let userNameLabel = UILabel()
    private let stackView = UIStackView()
    private let ntrpLabel = UILabel()
    private let mannerLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
    
    public func setProfileData(profileImage: String? = nil, username: String, ntrp: String?, manner: String, isPro: Bool) {
        self.stackView.isHidden = false
        self.descriptionLabel.isHidden = true
        self.ntrpTagView.isHidden = true
        
        if let profileImage = profileImage {
            self.profileImageView.updateServerImage(profileImage)
        }
        self.userNameLabel.text = username
        if let ntrp = ntrp {
            self.ntrpLabel.text = "NTRP \(ntrp)"
            self.ntrpLabel.setTargetAttributedText(targetString: "NTRP", fontType: .regular, fontSize: 14, color: UIColor.gray100)
            self.ntrpLabel.isHidden = false
        } else {
            self.ntrpLabel.isHidden = true
        }
        
        if manner.isEmpty {
            self.mannerLabel.isHidden = true
        } else {
            self.mannerLabel.text = "매너점수 \(manner)"
            self.mannerLabel.setTargetAttributedText(targetString: "매너점수", fontType: .regular, fontSize: 14, color: UIColor.gray100)
            self.mannerLabel.isHidden = false
        }
        self.proTagLabel.text = "PRO"
        self.proTagLabel.isHidden = isPro ? false : true
    }
    
    public func setAnalysisData(profileImage: String? = nil, username: String, ntrp: String?, playedYear: Int? = nil, age: Int? = nil, gender: String? = nil) {
        self.stackView.isHidden = true
        self.descriptionLabel.isHidden = false
        self.proTagLabel.isHidden = true
        
        if let profileImage = profileImage {
            self.profileImageView.updateServerImage(profileImage)
        }
        self.userNameLabel.text = username
        
        if let ntrp = ntrp {
            self.ntrpTagView.setNTRP(ntrp: ntrp)
            self.ntrpTagView.isHidden = false
        }
        
        var descriptionStr = ""
        
        if let playedYear = playedYear {
            descriptionStr += "구력 \(playedYear)년"
        }
        
        if let age = age {
            descriptionStr += " / \(age)세"
            if let gender = gender {
                descriptionStr += " \(gender)"
            }
        } else {
            if let gender = gender {
                descriptionStr += " / \(gender)"
            }
        }
        
        self.descriptionLabel.text = descriptionStr
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.profileImageView.addShadow()
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.cornerRadius = 40
        self.profileImageView.layer.masksToBounds = true
        
        self.proTagLabel.textColor = .white
        self.proTagLabel.font = .mediumFont(ofSize: 10)
        self.proTagLabel.clipsToBounds = true
        self.proTagLabel.layer.cornerRadius = 8
        self.proTagLabel.backgroundColor = .mainBlue
        self.proTagLabel.textAlignment = .center
        self.proTagLabel.isHidden = true
        
        self.ntrpTagView.isHidden = true
        
        self.userNameLabel.textColor = .black
        self.userNameLabel.font = .boldFont(ofSize: 22)
        
        self.ntrpLabel.textColor = .black
        self.ntrpLabel.font = .semiBoldFont(ofSize: 16)
        
        self.mannerLabel.textColor = .black
        self.mannerLabel.font = .semiBoldFont(ofSize: 16)
        
        self.descriptionLabel.textColor = .gray100
        self.descriptionLabel.setLineHeight(lineHeightMultiple: 1.25)
        self.descriptionLabel.font = .regularFont(ofSize: 14)
    }
    
    private func setStackView() {
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fill
        self.stackView.spacing = 12
        self.stackView.addArrangedSubviews(ntrpLabel, mannerLabel)
    }
    
    private func setLayout() {
        self.addSubviews([profileImageView, proTagLabel,
                          userNameLabel, stackView,
                          descriptionLabel, ntrpTagView])
        
        self.profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        self.proTagLabel.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(16)
            make.top.equalTo(self.profileImageView.snp.top).inset(6)
            make.centerX.equalTo(self.profileImageView.snp.trailing).offset(2)
        }
        
        self.ntrpTagView.snp.makeConstraints { make in
            make.top.equalTo(self.profileImageView.snp.top).inset(6)
            make.centerX.equalTo(self.profileImageView.snp.trailing).offset(2)
        }
        
        self.userNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.profileImageView.snp.bottom).offset(16)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userNameLabel.snp.bottom).offset(11)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userNameLabel.snp.bottom).offset(8)
        }
    }
}
