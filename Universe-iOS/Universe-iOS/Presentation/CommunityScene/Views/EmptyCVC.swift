//
//  EmptyCVC.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/02/20.
//

import UIKit
import UniverseKit
import SnapKit

class EmptyCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let bgView = UIView()
    private let bubbleImageView = UIImageView()
    private let emptyLabel = UILabel()
    private let emptyOwlImageView = UIImageView()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    convenience init(playType: PlayType) {
        self.init()
        setData(playType: playType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    func setData(playType: PlayType) {
        switch playType {
        case .live:
            emptyLabel.text = I18N.Community.ingEmpty
            emptyOwlImageView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(self.snp.width).multipliedBy(0.23)
                make.trailing.equalToSuperview().inset(12)
            }
        case .replay:
            emptyLabel.text = I18N.Community.replayEmpty
        }
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        bgView.backgroundColor = .lightGray200
        bgView.layer.cornerRadius = 5
        
        bubbleImageView.image = Icon.imgBubble.image
        emptyOwlImageView.image = Icon.icRecodingOwl.image
        
        emptyLabel.textColor = .black
        emptyLabel.font = .mediumFont(ofSize: 12)
        emptyLabel.setLineHeight(lineHeightMultiple: 1.08)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
    }
    
    private func setLayout() {
        self.addSubview(bgView)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubviews([emptyOwlImageView, bubbleImageView])
        
        emptyOwlImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.height.equalTo(self.snp.width).multipliedBy(0.23)
            make.trailing.equalToSuperview().inset(12)
        }
        
        bubbleImageView.snp.makeConstraints { make in
            make.trailing.equalTo(emptyOwlImageView.snp.leading).offset(-8)
            make.top.equalTo(emptyOwlImageView.snp.top)
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
        }
        
        bubbleImageView.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(6)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
