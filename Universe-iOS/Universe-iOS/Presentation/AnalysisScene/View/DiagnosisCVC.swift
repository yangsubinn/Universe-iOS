//
//  DiagnosisCVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/12.
//

import UIKit
import UniverseKit

class DiagnosisCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let iconLabel = UILabel()
    private let iconBackgroundView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.addShadow(type: .gray)
        
        iconLabel.text = "W"
        iconLabel.font = .semiBoldFont(ofSize: 16)
        iconLabel.textColor = .white
        iconLabel.textAlignment = .center
        
        iconBackgroundView.backgroundColor = .lightGray
        iconBackgroundView.layer.cornerRadius = 22
        
        titleLabel.font = .semiBoldFont(ofSize: 16)
        titleLabel.textColor = .black
        
        descriptionLabel.font = .regularFont(ofSize: 12)
        descriptionLabel.textColor = .gray100
    }
    
    private func setLayout() {
        self.addSubviews([iconBackgroundView, iconLabel,
                          titleLabel, descriptionLabel])
        
        iconBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.center.equalTo(iconBackgroundView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconBackgroundView.snp.trailing).offset(16)
            make.top.equalTo(iconBackgroundView.snp.top)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
    }
    
    // MARK: - Methods
    
    func setData(icon: String, title: String, description: String) {
        if icon == "W" {
            iconBackgroundView.backgroundColor = .subOrange
        } else {
            iconBackgroundView.backgroundColor = .subBlue
        }
        
        iconLabel.text = icon
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
