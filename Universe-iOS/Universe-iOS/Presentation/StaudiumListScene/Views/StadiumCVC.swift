//
//  StadiumCVC.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/11.
//

import UIKit
import UniverseKit

class StadiumCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var stadiumId: Int?
    
    // MARK: - UI Components
    
    private let backView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private let stadiumImageView = UIImageView().then {
        $0.image = Icon.imgCourt.image
    }
    
    private let stadiumLabel = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 16)
    }
    private let courtLabel = UILabel().then {
        $0.textColor = .gray100
        $0.font = .regularFont(ofSize: 12)
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
    }
    
    // MARK: - Methods
    
    public func setData(_ model: StadiumModel) {
        stadiumId = model.id
        stadiumLabel.text = model.name
        courtLabel.text = "야외 \(model.outdoorCourtCount)개 ﹒ 실내 \(model.indoorCourtCount)개"
        stadiumImageView.updateServerImage(model.imageURL)
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.addShadow(type: .gray)
    }
    
    private func setLayout() {
        self.addSubview(backView)
        backView.addSubviews([stadiumImageView, stadiumLabel, courtLabel])
        
        backView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        stadiumImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        stadiumLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.leading.equalTo(stadiumImageView.snp.trailing).offset(16)
        }
        courtLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(19)
            make.leading.equalTo(stadiumImageView.snp.trailing).offset(16)
        }
    }
}
