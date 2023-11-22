//
//  PlanView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/05.
//

import UIKit
import UniverseKit

class PlanView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let compositionLabel = UILabel()
    private let priceLabel = UILabel()
    
    // MARK: - Initialize
    
    init(planModel: PlanModel) {
        super.init(frame: .zero)
        self.setData(plan: planModel)
        self.setDefaultUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setDefaultUI() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.mainBlue.cgColor
        
        self.titleLabel.font = .mediumFont(ofSize: 16)
        self.compositionLabel.font = .regularFont(ofSize: 12)
        self.compositionLabel.numberOfLines = 0
        
        self.priceLabel.font = .semiBoldFont(ofSize: 14)
        self.priceLabel.textAlignment = .right
    }
    
    func setUI(isSeleted: Bool) {
        if isSeleted {
            self.layer.borderWidth = 1
            self.backgroundColor = .white
            self.titleLabel.textColor = .mainBlue
            self.compositionLabel.textColor = .black
            self.priceLabel.textColor = .mainBlue
            self.priceLabel.setTargetAttributedText(targetString: " / 월", fontType: .regular, fontSize: 12, color: .black)
            self.addShadow(type: .black)
        } else {
            self.layer.borderWidth = 0
            self.backgroundColor = .lightGray200
            self.titleLabel.textColor = .gray100
            self.compositionLabel.textColor = .gray100
            self.priceLabel.textColor = .gray100
            self.priceLabel.setTargetAttributedText(targetString: " / 월", fontType: .regular, fontSize: 12)
            self.layer.shadowOpacity = 0
        }
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
        self.addSubviews([titleLabel, compositionLabel, priceLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(20)
        }
        
        compositionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func setData(plan: PlanModel) {
        self.titleLabel.text = plan.title
        self.compositionLabel.text = plan.composition
        self.priceLabel.text = "\(plan.price) / 월"
    }
}
