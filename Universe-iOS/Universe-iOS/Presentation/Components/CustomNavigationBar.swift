//
//  CustomNavigationBar.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/03.
//

import UIKit
import UniverseKit

import SnapKit

@frozen
enum NavigationType {
    case left
    case center
    case withBackButton
    case withBackAndRightButton
    case withCloseButton
}

class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var naviType: NavigationType!
    
    // MARK: - UI Components
    
    private weak var pvc: UIViewController?
    private let titleLabel = UILabel()
    private let leftButton = UIButton()
    let rightButton = UIButton()

    // MARK: - Initialize
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        print("🥲customNaviBar - init")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("🥲customNaviBar - deinit")
    }
    
    // MARK: - UI & Layout
    
    private func setUI(_ type: NavigationType) {
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = (type == .left) ? .boldFont(ofSize: 24) : .semiBoldFont(ofSize: 20)
        leftButton.tintColor = .black
        
        switch type {
        case .withBackButton:
            leftButton.setImage(Icon.icBack.image.withRenderingMode(.alwaysTemplate), for: .normal)
        case .withCloseButton:
            leftButton.setImage(Icon.icClose.image.withRenderingMode(.alwaysTemplate), for: .normal)
        case .withBackAndRightButton:
            leftButton.setImage(Icon.icBack.image.withRenderingMode(.alwaysTemplate), for: .normal)
            rightButton.setTitleColor(.mainBlue, for: .normal)
            rightButton.setTitleColor(.subOrange, for: .selected)
            rightButton.setTitleColor(.subOrange, for: [.selected, .highlighted])
            rightButton.titleLabel?.font = .semiBoldFont(ofSize: 14)
        default:
            break
        }
    }
    
    public func setNavibar(_ pvc: UIViewController, title: String, type: NavigationType) {
        self.pvc = pvc
        self.naviType = type
        self.setTitle(title)
        self.setUI(type)
        self.setLayout(type)
        self.setAddTarget()
    }
    
    private func setLayout(_ type: NavigationType) {
        self.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        self.setTitleLayout(type)
        
        if type == .withBackButton || type == .withCloseButton {
            self.setLeftButtonLayout(type)
        } else if type == .withBackAndRightButton {
            self.setLeftButtonLayout(type)
            self.setRightButtonLayout()
        }
    }
    
    private func setTitleLayout(_ type: NavigationType) {
        self.addSubview(titleLabel)
        
        if type == .left {
            titleLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.top.equalToSuperview().inset(17)
            }
        } else {
            titleLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    private func setLeftButtonLayout(_ type: NavigationType) {
        self.addSubview(leftButton)
        
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setRightButtonLayout() {
        self.addSubview(rightButton)
        
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Methods
    
    public func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    public func setTitleAttribute(target: String, _ color: UIColor) {
        titleLabel.setTargetAttributedText(targetString: target,
                                           fontType: .semibold,
                                           color: color)
    }
    
    public func setRightButton(normal: String, selected: String) {
        self.rightButton.setTitle(normal, for: .normal)
        self.rightButton.setTitle(selected, for: .selected)
        self.rightButton.setTitle(selected, for: [.selected, .highlighted])
    }
    
    public func setTintColor(_ color: UIColor = .white) {
        self.titleLabel.textColor = color
        self.leftButton.tintColor = color
    }
    
    public func showTitleWithAnimation() {
        let isHidden = (titleLabel.alpha == 0)
        
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.titleLabel.alpha = isHidden ? 1 : 0
        }
    }
    
    @discardableResult
    public func hideTitle(_ hide: Bool) -> Self {
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.titleLabel.alpha = hide ? 0 : 1
        }

        return self
    }
    
    private func setAddTarget() {
        self.leftButton.addTarget(self, action: #selector(moveToPreviousView), for: .touchUpInside)
    }
    
    // MARK: - @objc
    
    @objc
    private func moveToPreviousView() {
        if self.naviType == .withBackButton || self.naviType == .withBackAndRightButton {
            pvc?.navigationController?.popViewController(animated: true)
        } else {
            pvc?.dismiss(animated: true)
        }
    }
}
