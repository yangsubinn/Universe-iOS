//
//  IngGameHeader.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/11.
//

import UIKit
import UniverseKit

class IngGameHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    private var stadiumId: Int?
    
    // MARK: - UI Components
    
    private let backView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private let ingGameImageView = UIImageView()
    
    private let ingGameLabel = UILabel().then {
        $0.text = "경기 중"
        $0.textColor = .white
        $0.font = .semiBoldFont(ofSize: 14)
        $0.backgroundColor = .subOrange
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    private let stadiumLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldFont(ofSize: 20)
    }
    private let courtLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .mediumFont(ofSize: 14)
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
        courtLabel.text = "야외 \(model.courtNumber)번 코트"
        ingGameImageView.updateServerImage(model.imageURL)
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.addShadow(type: .gray)
    }
    
    private func setLayout() {
        self.addSubview(backView)
        backView.addSubviews([ingGameImageView, ingGameLabel, stadiumLabel, courtLabel])
        
        backView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        ingGameImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        ingGameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.width.equalTo(60)
        }
        courtLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
        stadiumLabel.snp.makeConstraints { make in
            make.bottom.equalTo(courtLabel.snp.top).offset(-5)
            make.leading.equalToSuperview().inset(16)
        }
    }
}
