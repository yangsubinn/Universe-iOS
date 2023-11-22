//
//  ReplayLiveCVC.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/07.
//

import UIKit
import UniverseKit

class ReplayLiveCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var liveGameId: Int?
    var isCommunity: Bool = true
    private var homeProfiles: [UIImageView] = []
    private var awayProfiles: [UIImageView] = []
    private var homeNicknames: [UILabel] = []
    private var awayNicknames: [UILabel] = []
    
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
    private var homeProfileImageView1 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    private var homeProfileImageView2 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    private var awayProfileImageView1 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    private var awayProfileImageView2 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    private var homeNicknameLabel1 = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 14)
    }
    private var homeNicknameLabel2 = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 14)
    }
    private var awayNicknameLabel1 = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 14)
    }
    private var awayNicknameLabel2 = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 14)
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
        stadiumNameLabel.text = nil
        homeScoreLabel.text = nil
        awayScoreLabel.text = nil
        resetStackView()
    }
    
    // MARK: - Methods
    
    public func setData(_ model: CommunityModel) {
        dateLabel.text = model.matchStartTime
        homeScoreLabel.text = "\(model.homeWonGameCount)"
        awayScoreLabel.text = "\(model.awayWonGameCount)"
        stadiumNameLabel.text = "\(model.stadiumName) (야외 3번 코트)"
        homeProfiles = [homeProfileImageView1, homeProfileImageView2]
        awayProfiles = [awayProfileImageView1, awayProfileImageView2]
        homeNicknames = [homeNicknameLabel1, homeNicknameLabel2]
        awayNicknames = [awayNicknameLabel1, awayNicknameLabel2]
        
        model.homeUserProfileImageUrls.enumerated().forEach {
            homeProfiles[$0].updateServerImage($1)
            homeProfileStackView.addArrangedSubview(homeProfiles[$0])
        }
        model.awayUserProfileImageUrls.enumerated().forEach {
            awayProfiles[$0].updateServerImage($1)
            awayProfileStackView.addArrangedSubview(awayProfiles[$0])
        }
        model.homeUserNames.enumerated().forEach {
            homeNicknames[$0].text = $1
            homeNicknameStackView.addArrangedSubview(homeNicknames[$0])
        }
        model.awayUserNames.enumerated().forEach {
            awayNicknames[$0].text = $1
            awayNicknameStackView.addArrangedSubview(awayNicknames[$0])
        }
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.addShadow(type: .gray)
    }
    
    private func resetStackView() {
        homeNicknameStackView.removeAllFromSuperview()
        homeProfileStackView.removeAllFromSuperview()
        awayNicknameStackView.removeAllFromSuperview()
        awayProfileStackView.removeAllFromSuperview()
    }
    
    private func setLayout() {
        self.addSubviews([stadiumNameLabel,
                          dateLabel,
                          homeStackView, versusLabel, awayStackView,
                          homeScoreLabel, dividerLabel, awayScoreLabel])
        homeStackView.addArrangedSubviews([homeNicknameStackView, homeProfileStackView])
        awayStackView.addArrangedSubviews([awayProfileStackView, awayNicknameStackView])
        
        stadiumNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(12)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        versusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stadiumNameLabel.snp.bottom).offset(18)
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
    }
}
