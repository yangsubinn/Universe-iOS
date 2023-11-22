//
//  IngLiveCVC.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/07.
//

import UIKit
import UniverseKit

class IngLiveCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var liveGameId: Int?
    private var homeProfiles: [UIImageView] = []
    private var awayProfiles: [UIImageView] = []
    private var homeNicknames: [UILabel] = []
    private var awayNicknames: [UILabel] = []
    
    // MARK: - UI Components
    
    private let backView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    private var thumbnailImage = UIImageView()
    private var dateLabel = UILabel().then {
        $0.text = "2023.02.21 (월) 17:10"
        $0.textColor = .white
        $0.font = .regularFont(ofSize: 12)
    }
    private var scoresLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBoldFont(ofSize: 40)
        $0.sizeToFit()
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
            make.width.height.equalTo(24)
        }
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    private var homeProfileImageView2 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    private var awayProfileImageView1 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    private var awayProfileImageView2 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(24)
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
        $0.distribution = .fill
        $0.spacing = 5
    }
    private var versusLabel = UILabel().then {
        $0.text = "vs"
        $0.textColor = .subBlue
        $0.font = .mediumFont(ofSize: 12)
    }
    private var awayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 5
    }
    private var stadiumNameLabel = UILabel().then {
        $0.textColor = .gray100
        $0.font = .regularFont(ofSize: 10)
        $0.sizeToFit()
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
        thumbnailImage.image = nil
        scoresLabel.text = nil
        stadiumNameLabel.text = nil
    }
    
    // MARK: - Methods
    
    public func setData(_ model: CommunityModel) {
        thumbnailImage.updateServerImage(model.thumbnailImageURL)
        dateLabel.text = model.matchStartTime
        scoresLabel.text = "\(model.homeWonGameCount) - \(model.awayWonGameCount)"
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
        }
        model.awayUserNames.enumerated().forEach {
            awayNicknames[$0].text = $1
        }
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.addShadow(type: .gray)
    }
    
    private func setLayout() {
        self.addSubview(backView)
        backView.addSubviews([thumbnailImage, scoresLabel,
                          homeStackView, versusLabel, awayStackView, dateLabel,
                          stadiumNameLabel])
        homeNicknameStackView.addArrangedSubviews([homeNicknameLabel1, homeNicknameLabel2])
        awayNicknameStackView.addArrangedSubviews([awayNicknameLabel1, awayNicknameLabel2])
        homeStackView.addArrangedSubviews([homeProfileStackView, homeNicknameStackView])
        awayStackView.addArrangedSubviews([awayProfileStackView, awayNicknameStackView])
        
        backView.snp.makeConstraints { make in
            make.center.top.leading.equalToSuperview()
        }
        thumbnailImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.leading.equalToSuperview()
            make.height.equalTo(140)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        scoresLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(36)
        }
        stadiumNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(5)
        }
        versusLabel.snp.makeConstraints { make in
            make.bottom.equalTo(stadiumNameLabel.snp.top).offset(-12)
            make.leading.equalToSuperview().inset(10)
        }
        awayStackView.snp.makeConstraints { make in
            make.centerY.equalTo(versusLabel.snp.centerY)
            make.leading.equalTo(versusLabel.snp.trailing).offset(5)
            make.height.equalTo(24)
        }
        homeStackView.snp.makeConstraints { make in
            make.bottom.equalTo(awayStackView.snp.top).offset(-3)
            make.leading.equalToSuperview().inset(10)
            make.height.equalTo(24)
        }
    }
}
