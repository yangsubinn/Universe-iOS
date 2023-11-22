//
//  HeaderCell.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/03.
//

import UIKit
import UniverseKit

class HeaderCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.setLayout()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
    }
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        self.addSubviews([naviBar])
        
        naviBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
}
