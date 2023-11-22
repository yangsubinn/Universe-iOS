//
//  BadgeConditionView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/05.
//

import UIKit

class BadgeConditionView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let conditionLabel = UILabel()
    private let countLabel = UILabel()
    
    // MARK: - Initialize
    
    init(condition: String, count: String) {
        super.init(frame: .zero)
        self.setUI()
        self.setLayout()
        self.setData(condition: condition, count: count)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.layer.cornerRadius = 5
        self.backgroundColor = .lightGray200
        
        self.conditionLabel.font = .mediumFont(ofSize: 10)
        self.conditionLabel.textColor = .gray100
        
        self.countLabel.font = .mediumFont(ofSize: 10)
        self.countLabel.textColor = .mainBlue
        self.countLabel.textAlignment = .right
    }
    
    private func setLayout() {
        
        self.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        self.addSubviews([conditionLabel, countLabel])
        
        conditionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    private func setData(condition: String, count: String) {
        self.conditionLabel.text = condition
        self.countLabel.text = count
    }
}
