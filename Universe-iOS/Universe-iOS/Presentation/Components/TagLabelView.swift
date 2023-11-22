//
//  TagLabelView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/11.
//

import UIKit
import UniverseKit

class TagLabelView: UIStackView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        titleLabel.font = .mediumFont(ofSize: 10)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        self.distribution = .fill
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = .subBlue
        self.axis = .horizontal
    }
    
    private func setLayout() {
        let rightView = UIView()
        let leftView = UIView()
        
        self.addArrangedSubviews([leftView, titleLabel, rightView])
        
        leftView.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.height.equalTo(16)
        }
        
        rightView.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.height.equalTo(16)
        }
    }
    
    // MARK: - Methods
    
    func setNTRP(ntrp: String) {
        self.titleLabel.text = "NTRP \(ntrp)"
    }
}
