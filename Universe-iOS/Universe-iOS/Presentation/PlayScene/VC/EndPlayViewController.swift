//
//  EndPlayViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/17.
//

import SnapKit
import Then
import UIKit
import UniverseKit
import RxSwift
import RxRelay
import RxCocoa

class EndPlayViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: EndPlayViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    var isDone = true
    var matchId: Int?
    
    // MARK: - UI Components
    
    private var popView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    private var titleLabel = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 20)
        $0.text = I18N.Play.endWarning
        $0.sizeToFit()
    }
    private var descriptionLabel = UILabel().then {
        $0.text = I18N.Play.endDescription
        $0.font = .mediumFont(ofSize: 14)
        $0.textColor = .gray100
        $0.sizeToFit()
    }
    private lazy var noButton = CustomButton(title: I18N.Default.no, type: .normal, size: .small)
    private lazy var endPlayButton = CustomButton(title: I18N.Play.endPlay, type: .ended, size: .small)
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
        bindViewModels()
        bindActions()
    }
}

extension EndPlayViewController {
    
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
        buttonStackView.addArrangedSubviews([noButton, endPlayButton])
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func bindViewModels() {
        let input = EndPlayViewModel.Input(matchEndButtonTapEvent: self.endPlayButton.rx.tap.filter({ [weak self] in self?.isDone == true }).map { [weak self] _ in
            return MatchRequestModel(matchId: self?.matchId ?? 0)})
        let output = self.viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.endMatchStatus
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                print("😀 endMatch", model)
                owner.dismiss(animated: true, completion: {
                    let baseTBC = owner.moduleFactory.makeBaseVC()
                    owner.presentationController?.presentingViewController.changeRootViewController(baseTBC)
                    baseTBC.showToast(message: I18N.Play.gameFinished, bottom: 66)
                })
            }.disposed(by: disposeBag)
        
        output.error
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.showNetworkAlert { _ in
                    owner.dismiss(animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindActions() {
        noButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: self.disposeBag)
        
        endPlayButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.endPlay()
            }.disposed(by: self.disposeBag)
    }
    
    private func endPlay() {
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            if !self.isDone {
                // 세트 먼저 종료해주세요 토스트
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController?.showToast(message: I18N.Play.endOngoingSet, bottom: 100)
                }
            }
        })
    }
    
    // MARK: - @objc
    
    @objc
    private func dismissPopUp() {
        self.dismiss(animated: true)
    }
}
