//
//  StadiumDetailCVC.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/16.
//

import UIKit
import UniverseKit

class StadiumDetailCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let stadiumImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = Icon.imgCourt.image
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
    
    public func setImageData(_ thumailURL: String) {
        stadiumImageView.updateServerImage(thumailURL)
    }
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        self.addSubview(stadiumImageView)
        
        stadiumImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(274)
        }
    }
}
