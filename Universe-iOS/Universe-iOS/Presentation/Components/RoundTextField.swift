//
//  RoundTextField.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/03.
//

import UIKit
import UniverseKit

@frozen
enum TextFieldType {
    case id
    case password
}

class RoundTextField: UIView {
    // MARK: - Properties
    
    private var textFieldType: TextFieldType!
    
    // MARK: - UI Components
    
    let textFieldTitle = UILabel()
    lazy var textField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.font = .mediumFont(ofSize: 16)
        $0.addTarget(self, action: #selector(setTextFieldBorder(_:)), for: .editingChanged)
    }
    let passwordEyeButton = UIButton().then {
        $0.setImage(Icon.icHidden.image, for: .normal)
    }
    
    init(_ type: TextFieldType) {
        super.init(frame: .zero)
        self.setUI()
        self.setupAutoLayout()
        self.setTitle(type)
        self.setDelegate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI & Layout
    
    private func setTitle(_ type: TextFieldType) {
        switch type {
        case .id:
            textField.isSecureTextEntry = false
            passwordEyeButton.isHidden = true
            textFieldTitle.setupLabel(text: "아이디",
                                      color: .gray100,
                                      font: .regularFont(ofSize: 12))
        case .password:
            textFieldTitle.setupLabel(text: "비밀번호",
                                      color: .gray100,
                                      font: .regularFont(ofSize: 12))
        }
    }
    
    private func setUI() {
        layer.borderColor = UIColor.lightGray100.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 30
        if textField.isFirstResponder {
            layer.borderColor = UIColor.mainBlue.cgColor
        }
    }
    
    private func setupAutoLayout() {
        addSubviews([textFieldTitle, textField, passwordEyeButton])
        textFieldTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(11)
            make.leading.equalToSuperview().inset(26)
        }
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textFieldTitle.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(26)
        }
        passwordEyeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func setDelegate() {
        textField.delegate = self
    }
    
    // MARK: - @objc
    
    @objc
    private func setTextFieldBorder(_ sender: UITextField) {
        setUI()
    }
}

// MARK: - UITextFieldDelegate

extension RoundTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setUI()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setUI()
    }
}
