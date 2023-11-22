//
//  AddPlayerHeaderView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import UIKit
import UniverseKit

class AddPlayerHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    
    // MARK: - Initialize
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        titleLabel.font = .regularFont(ofSize: 14)
        titleLabel.textColor = .gray100
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func setHeaderData(title: String) {
        self.titleLabel.text = title
    }
}
