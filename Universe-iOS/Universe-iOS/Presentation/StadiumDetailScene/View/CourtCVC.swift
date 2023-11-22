//
//  CourtCVC.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/16.
//

import SnapKit
import Then
import UIKit
import UniverseKit

class CourtCVC: UICollectionViewCell {
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let courtImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    private var courtNameLabel = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 16)
    }
    private var timeLimitLabel = UILabel().then {
        $0.text = "이용시간: 1시간"
        $0.font = .regularFont(ofSize: 12)
        $0.textColor = .gray100
    }
    private var priceLabel = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 14)
        $0.textColor = .mainBlue
        $0.sizeToFit()
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    public func setData(_ model: CourtModel, number: Int) {
        courtImageView.updateServerImage(model.imageURL)
        priceLabel.text = "\(model.price)원"
        courtNameLabel.text = "\(number)번 코트"
    }
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        self.addSubviews([courtImageView, courtNameLabel, timeLimitLabel, priceLabel])
        
        courtImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        courtNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.leading.equalTo(courtImageView.snp.trailing).offset(15)
        }
        timeLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(courtNameLabel.snp.bottom).offset(9)
            make.leading.equalTo(courtImageView.snp.trailing).offset(15)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(7)
        }
    }
}
