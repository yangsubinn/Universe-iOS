//
//  SubtitleHeaderView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/12.
//

import UIKit
import UniverseKit

class SubtitleHeaderView: UICollectionReusableView {
        
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    
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
        titleLabel.textColor = .gray100
        titleLabel.font = .regularFont(ofSize: 14)
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Methods
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
}
