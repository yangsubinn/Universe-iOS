//
//  PaymentView.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/06.
//

import UIKit
import UniverseKit

class PaymentButton: UIButton {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    // MARK: - Initialize
    
    init(_ title: String) {
        super.init(frame: .zero)
        self.setDefaultUI()
        self.setTitle(title, for: .normal)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setDefaultUI() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.mainBlue.cgColor
        self.setTitleColor(.mainBlue, for: .selected)
        self.setTitleColor(.gray100, for: .normal)
    }
    
    func setUI(isSeleted: Bool) {
        if isSeleted {
            self.layer.borderWidth = 1
            self.backgroundColor = .white
            self.titleLabel?.font = .semiBoldFont(ofSize: 14)
            self.isSelected = true
        } else {
            self.layer.borderWidth = 0
            self.backgroundColor = .lightGray200
            self.titleLabel?.font = .regularFont(ofSize: 14)
            self.isSelected = false
        }
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    // MARK: - Methods
}
