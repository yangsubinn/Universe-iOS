//
//  LoginViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/03.
//

import UIKit
import Then
import UniverseKit
import RxSwift
import RxRelay
import RxCocoa

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: LoginViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let logoImageView = UIImageView().then {
        $0.image = Icon.logo.image
    }
    private lazy var idView = RoundTextField(.id).then {
        $0.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    private lazy var passwordView = RoundTextField(.password).then {
        $0.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    private lazy var idTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapId(_:)))
    private lazy var pwTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPw(_:)))
    private let findPwButton = UIButton().then {
        $0.setTitle(I18N.Login.findPassword, for: .normal)
        $0.titleLabel?.font = .regularFont(ofSize: 12)
        $0.setTitleColor(.gray100, for: .normal)
        $0.setUnderline()
    }
    private lazy var loginButton = CustomButton(title: I18N.Login.login, type: .disabled, size: .large)
    private let notYetButton = UIButton().then {
        $0.setTitle(I18N.Login.notMember, for: .normal)
        $0.titleLabel?.font = .regularFont(ofSize: 12)
        $0.setTitleColor(.gray100, for: .normal)
        $0.setUnderline()
    }
    private let leftDividerLine = UIView().then {
        $0.backgroundColor = .lightGray100
    }
    private let rightDividerLine = UIView().then {
        $0.backgroundColor = .lightGray100
    }
    private let socialLoginLabel = UILabel().then {
        $0.setupLabel(text: I18N.Login.socialLogin, color: .gray100, font: .regularFont(ofSize: 12))
        $0.sizeToFit()
    }
    private lazy var socialLoginTitleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 8
    }
    private lazy var socialLoginStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 24
    }
    private let appleLoginButton = UIButton().then {
        $0.setImage(Icon.btnApple.image, for: .normal)
    }
    private let kakaoLoginButton = UIButton().then {
        $0.setImage(Icon.btnKakao.image, for: .normal)
    }
    private let naverLoginButton = UIButton().then {
        $0.setImage(Icon.btnNaver.image, for: .normal)
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindViewModels()
    }
    
}

extension LoginViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.dismissKeyboardWhenTappedAround()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        idView.addGestureRecognizer(idTapGestureRecognizer)
        passwordView.addGestureRecognizer(pwTapGestureRecognizer)
    }
    
    private func setLayout() {
        view.addSubviews([logoImageView, idView, passwordView,
                          findPwButton, loginButton, notYetButton,
                          socialLoginTitleStackView, socialLoginStackView])
        socialLoginTitleStackView.addArrangedSubviews([leftDividerLine, socialLoginLabel, rightDividerLine])
        socialLoginStackView.addArrangedSubviews([appleLoginButton, kakaoLoginButton,
                                                  naverLoginButton])
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(69)
            make.leading.equalToSuperview().inset(62)
        }
        idView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(50)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(58)
        }
        passwordView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(idView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(58)
        }
        findPwButton.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(findPwButton.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }
        notYetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(12)
        }
        leftDividerLine.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview().offset(7)
        }
        socialLoginLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
        rightDividerLine.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview().offset(7)
        }
        socialLoginTitleStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(notYetButton.snp.bottom).offset(52)
            make.leading.equalToSuperview().inset(16)
        }
        socialLoginStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(socialLoginTitleStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(80)
        }
    }
    
    // MARK: - Methods
    
    private func bindViewModels() {
        let input = LoginViewModel.Input(buttonTapEvent:
                                            loginButton.rx.tap.map({ _ in
            return LoginRequestModel(email: self.idView.textField.text ?? "",
                              password: self.passwordView.textField.text ?? "")}).asObservable())
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.loginModel
            .compactMap { $0 }
            .subscribe { _ in
                let baseTBC = self.moduleFactory.makeBaseVC()
                self.navigationController?.changeRootViewController(baseTBC)
            }.disposed(by: self.disposeBag)
        
        output.loginError
            .compactMap { $0 }
            .subscribe { _ in
                self.showToast(message: I18N.Login.checkAccountInfo, bottom: 70)
            }.disposed(by: self.disposeBag)
        
        output.loginFail
            .compactMap { $0 }
            .subscribe { _ in
                self.showNetworkAlert()
            }.disposed(by: self.disposeBag)
    }
    
    // MARK: - @objc
    
    @objc
    func didTapId(_ sender: UITapGestureRecognizer) {
        idView.textField.becomeFirstResponder()
    }
    
    @objc
    func didTapPw(_ sender: UITapGestureRecognizer) {
        passwordView.textField.becomeFirstResponder()
    }
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        if idView.textField.hasText && passwordView.textField.hasText {
            loginButton.changeState(.abled)
        } else {
            loginButton.changeState(.disabled)
        }
    }
}
