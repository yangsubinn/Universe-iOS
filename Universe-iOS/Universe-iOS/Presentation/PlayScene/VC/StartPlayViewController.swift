//
//  StartPlayViewController.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/02/21.
//

import UIKit
import UniverseKit
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

class StartPlayViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: PlayViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private var popView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    private var titleLabel = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 20)
        $0.text = I18N.Play.startPlayLong
        $0.sizeToFit()
    }
    private var descriptionLabel = UILabel().then {
        $0.text = I18N.Play.startFirstGame
        $0.setLineHeight(lineHeightMultiple: 1.25)
        $0.font = .mediumFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .gray100
    }
    private lazy var startMatchButton = CustomButton(title: I18N.Default.no, type: .normal, size: .small)
    private lazy var startLiveButton = CustomButton(title: I18N.Play.startLive, type: .ended, size: .small)
    private let buttonStackView = UIStackView().then {
        $0.spacing = 9
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bindActions()
    }
}

extension StartPlayViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .blackAlpha
        self.navigationController?.navigationBar.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    private func setLayout() {
        view.addSubviews([popView])
        popView.addSubviews([titleLabel, descriptionLabel, buttonStackView])
        
        popView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().inset(25)
            make.height.equalTo(popView.snp.width).multipliedBy(0.61)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(32)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        buttonStackView.addArrangedSubviews([startMatchButton, startLiveButton])
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func bindActions() {
        startMatchButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        startLiveButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.dismiss(animated: true) {
                    owner.viewModel.startLiveButtonTapped.accept(true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - @objc
    
    @objc
    private func dismissPopUp() {
        self.dismiss(animated: true)
    }
}
