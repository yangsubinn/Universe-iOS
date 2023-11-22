//
//  LiveHeader.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/07.
//

import Then
import UIKit
import UniverseKit

final class LiveHeader: UIView {
    
    // MARK: - Properties
    
    var pushViewController: (() -> Void)?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 18)
    }
    private lazy var moreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.titleLabel?.font = .semiBoldFont(ofSize: 14)
        $0.setImage(Icon.icChevronRight.image, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(touchMoreButton(_:)), for: .touchUpInside)
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: - Initialize
    
    init(_ liveType: LiveType) {
        super.init(frame: .zero)
        self.setData(liveType: liveType)
        self.setUI()
        self.setLayout()
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    public func setData(liveType: LiveType) {
        self.titleLabel.text = "\(liveType.title)"
        self.titleLabel.setTargetAttributedText(targetString: "LIVE", fontType: .semibold,
                                                fontSize: 18, color: .subOrange)
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.layer.cornerRadius = 5
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel, moreButton])
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(17)
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(17)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchMoreButton(_ sender: UIButton) {
        pushViewController?()
    }
}
