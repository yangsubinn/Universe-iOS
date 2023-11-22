//
//  PlanCVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/04.
//

import UIKit
import UniverseKit

class PlanCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let ballImageView = UIImageView()
    private let titleLabel = UILabel()
    private let morePlanButton = MoreButton(title: I18N.My.morePlan, font: .semiBoldFont(ofSize: 12), tintColor: .mainBlue)
    private let divideLineView = UIView()
    private let planTitleLabel = UILabel()
    private let planCompositionLabel = UILabel()
    private let planPriceLabel = UILabel()
    
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
    
    func setData(plan: PlanType) {
        planTitleLabel.text = "\(plan.rawValue) Plan"
        planCompositionLabel.text = plan.composition
        planPriceLabel.text = plan.price
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.layer.borderColor = UIColor.mainBlue.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        self.ballImageView.image = Icon.icBall.image
        
        self.titleLabel.text = I18N.Default.pixelcastUniverse
        self.titleLabel.font = .mediumFont(ofSize: 14)
        self.titleLabel.textColor = .black
        
        self.divideLineView.backgroundColor = .lightGray200
        
        self.planTitleLabel.font = .regularFont(ofSize: 14)
        self.planTitleLabel.textColor = .black
        
        self.planCompositionLabel.font = .regularFont(ofSize: 12)
        self.planCompositionLabel.textColor = .gray100
        
        self.planPriceLabel.font = .regularFont(ofSize: 12)
        self.planPriceLabel.textColor = .gray100
        
        self.morePlanButton.isUserInteractionEnabled = false
    }
    
    private func setLayout() {
        self.addSubviews([ballImageView, titleLabel, morePlanButton,
                         divideLineView, planTitleLabel,
                         planCompositionLabel, planPriceLabel])
        
        ballImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ballImageView.snp.centerY)
            make.leading.equalTo(ballImageView.snp.trailing).offset(6)
        }
        
        morePlanButton.snp.makeConstraints { make in
            make.centerY.equalTo(ballImageView)
            make.trailing.equalToSuperview().inset(16)
        }
        
        divideLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(ballImageView.snp.bottom).offset(20)
            make.height.equalTo(2)
        }
        
        planTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(divideLineView.snp.bottom).offset(11)
        }
        
        planCompositionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(planTitleLabel.snp.bottom).offset(5)
        }
        
        planPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(planCompositionLabel.snp.centerY)
        }
    }
}
