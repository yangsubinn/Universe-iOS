//
//  CourtHeader.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/16.
//

import Then
import SnapKit
import UIKit
import UniverseKit

class CourtHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let courtTitleLabel = UILabel().then {
        $0.textColor = .mainBlue
        $0.font = .boldFont(ofSize: 16)
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
    
    public func setData(_ courtType: CourtType) {
        switch courtType {
        case .indoor:
            courtTitleLabel.text = I18N.Stadium.indoor
        case .outdoor:
            courtTitleLabel.text = I18N.Stadium.outdoor
        }
    }
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        self.addSubview(courtTitleLabel)
        courtTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.leading.equalToSuperview()
        }
    }
}
