//
//  MatchAnalysisView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/12.
//

import UIKit
import UniverseKit

class MatchAnalysisView: UIView {
    
    // MARK: - Properties
    
    private var liveGameId: Int?
    
    // MARK: - UI Components
    private var stadiumNameLabel = UILabel().then {
        $0.textColor = .gray100
        $0.font = .regularFont(ofSize: 12)
    }
    private var dateLabel = UILabel().then {
        $0.font = .regularFont(ofSize: 12)
        $0.textColor = .gray50
    }
    private var homeProfileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = -5
    }
    private var homeNicknameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
    }
    private var awayProfileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = -5
    }
    private var awayNicknameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
    }
    private var homeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private var versusLabel = UILabel().then {
        $0.text = "vs"
        $0.textColor = .subBlue
        $0.font = .mediumFont(ofSize: 12)
    }
    private var awayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private var homeScoreLabel = UILabel().then {
        $0.textColor = .mainBlue
        $0.font = .semiBoldFont(ofSize: 18)
    }
    private var dividerLabel = UILabel().then {
        $0.text = "-"
        $0.textColor = .gray100
        $0.font = .mediumFont(ofSize: 14)
        $0.sizeToFit()
    }
    private var awayScoreLabel = UILabel().then {
        $0.textColor = .mainBlue
        $0.font = .semiBoldFont(ofSize: 18)
    }
    private var emptyOwlImageView = UIImageView().then {
        $0.image = Icon.icEmptyOwl.image
    }
    private var emptyBubbleImageView = UIImageView().then {
        $0.image = Icon.imgBubble.image
    }
    private var emptyLabel = UILabel().then {
        $0.text = I18N.Analysis.emptyMatch
        $0.textColor = .black
        $0.font = .mediumFont(ofSize: 12)
        $0.setLineHeight(lineHeightMultiple: 1.08)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func setData(date: String, homeScore: Int, awayScore: Int,
                        homeProfileImages: [String?], awayProfileImages: [String?],
                        homeNicknames: [String], awayNicknames: [String], stadiumName: String) {
        [emptyOwlImageView, emptyBubbleImageView, emptyLabel].forEach { $0.isHidden = true }
        [stadiumNameLabel, dateLabel,
         homeStackView, versusLabel, awayStackView,
         homeScoreLabel, dividerLabel, awayScoreLabel].forEach {
            $0.isHidden = false
        }
        
        dateLabel.text = date
        homeScoreLabel.text = "\(homeScore)"
        awayScoreLabel.text = "\(awayScore)"
        stadiumNameLabel.text = stadiumName
        setPlayers(homeProfiles: homeProfileImages, awayProfiles: awayProfileImages, homeNicknames: homeNicknames, awayNicknames: awayNicknames)
    }
    
    func setEmptyView() {
        [emptyOwlImageView, emptyBubbleImageView, emptyLabel].forEach { $0.isHidden = false }
        [stadiumNameLabel, dateLabel,
         homeStackView, versusLabel, awayStackView,
         homeScoreLabel, dividerLabel, awayScoreLabel].forEach {
            $0.isHidden = true
        }
    }
    
    private func resetStackView() {
        homeNicknameStackView.removeAllFromSuperview()
        homeProfileStackView.removeAllFromSuperview()
        awayNicknameStackView.removeAllFromSuperview()
        awayProfileStackView.removeAllFromSuperview()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .lightGray200
        self.layer.cornerRadius = 5
    }
    
    func changeBackgroundColor(color: UIColor) {
        self.backgroundColor = color
        self.layer.cornerRadius = 5
    }
    
    private func setPlayers(homeProfiles: [String?], awayProfiles: [String?], homeNicknames: [String?], awayNicknames: [String?]) {
        resetStackView()
        homeProfiles.forEach {
            let profileImageView = UIImageView()
            if let imageURL = $0 {
                profileImageView.updateServerImage(imageURL)
            } else {
                profileImageView.image = Icon.icProfileBlue.image
            }
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.cornerRadius = 10
            profileImageView.snp.makeConstraints { make in
                make.width.height.equalTo(20)
            }
            homeProfileStackView.addArrangedSubview(profileImageView)
        }
        awayProfiles.forEach {
            let profileImageView = UIImageView()
            if let imageURL = $0 {
                profileImageView.updateServerImage(imageURL)
            } else {
                profileImageView.image = Icon.icProfileBlue.image
            }
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.cornerRadius = 10
            profileImageView.snp.makeConstraints { make in
                make.width.height.equalTo(20)
            }
            awayProfileStackView.addArrangedSubview(profileImageView)
        }
        homeNicknames.forEach {
            let nicknameLabel = UILabel()
            nicknameLabel.text = $0
            nicknameLabel.font = .semiBoldFont(ofSize: 14)
            homeNicknameStackView.addArrangedSubview(nicknameLabel)
        }
        awayNicknames.forEach {
            let nicknameLabel = UILabel()
            nicknameLabel.text = $0
            nicknameLabel.font = .semiBoldFont(ofSize: 14)
            awayNicknameStackView.addArrangedSubview(nicknameLabel)
        }
    }
    
    private func setLayout() {
        self.addSubviews([stadiumNameLabel,
                          dateLabel,
                          homeStackView, versusLabel, awayStackView,
                          homeScoreLabel, dividerLabel, awayScoreLabel])
        
        stadiumNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(12)
        }
        versusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stadiumNameLabel.snp.bottom).offset(18)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        homeStackView.snp.makeConstraints { make in
            make.centerY.equalTo(versusLabel.snp.centerY)
            make.trailing.equalTo(versusLabel.snp.leading).offset(-21)
            make.height.equalTo(20)
        }
        awayStackView.snp.makeConstraints { make in
            make.centerY.equalTo(versusLabel.snp.centerY)
            make.leading.equalTo(versusLabel.snp.trailing).offset(21)
            make.height.equalTo(20)
        }
        dividerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(17)
        }
        homeScoreLabel.snp.makeConstraints { make in
            make.centerX.equalTo(homeStackView.snp.centerX)
            make.centerY.equalTo(dividerLabel.snp.centerY)
            make.bottom.equalToSuperview().inset(14)
        }
        awayScoreLabel.snp.makeConstraints { make in
            make.centerX.equalTo(awayStackView.snp.centerX)
            make.centerY.equalTo(dividerLabel.snp.centerY)
            make.bottom.equalToSuperview().inset(14)
        }
        
        homeStackView.addArrangedSubviews([homeNicknameStackView, homeProfileStackView])
        awayStackView.addArrangedSubviews([awayProfileStackView, awayNicknameStackView])
        
        self.addSubviews([emptyOwlImageView, emptyBubbleImageView, emptyLabel])
        
        emptyOwlImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.height.equalTo(self.snp.width).multipliedBy(0.23)
            make.trailing.equalToSuperview().inset(12)
        }
        
        emptyBubbleImageView.snp.makeConstraints { make in
            make.trailing.equalTo(emptyOwlImageView.snp.leading).offset(-8)
            make.centerY.equalToSuperview().offset(-2)
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(emptyBubbleImageView.snp.centerX)
            make.top.equalTo(emptyBubbleImageView.snp.top).inset(6)
        }
    }
}
