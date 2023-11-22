//
//  DefaultCVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/12.
//

import UIKit
import UniverseKit

class DefaultCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let contentLabel = UILabel()
    private let scoreLabel = UILabel()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.text = ""
        scoreLabel.text = ""
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        contentLabel.font = .regularFont(ofSize: 14)
        contentLabel.setLineHeight(lineHeightMultiple: 1.37)
        contentLabel.textColor = .gray100
        
        scoreLabel.font = .semiBoldFont(ofSize: 16)
        scoreLabel.setLineHeight(lineHeightMultiple: 1.37)
        scoreLabel.textColor = .black
        scoreLabel.textAlignment = .right
    }
    
    private func setLayout() {
        self.addSubviews([contentLabel, scoreLabel])
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(9)
            make.centerY.equalToSuperview()
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(11)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func setData(content: String, score: String, unit: String) {
        contentLabel.text = content
        scoreLabel.text = "\(score)\(unit)"
    }
}
