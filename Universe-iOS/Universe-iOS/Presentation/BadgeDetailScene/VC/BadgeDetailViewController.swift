//
//  BadgeDetailViewController.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/05.
//

import UIKit
import UniverseKit
import RxRelay
import RxCocoa
import RxSwift

class BadgeDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: BadgeDetailViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    
    private let popupView = UIView()
    private let badgeImageView = UIImageView()
    private let badgeNameLabel = UILabel()
    private let badgeDescriptionLabel = UILabel()
    private let badgeConditionStack = UIStackView()
    private let badgeButton = CustomButton(title: I18N.Default.ok, type: .normal, size: .small)
    
    // MARK: - View Life Cycles
    
    override func loadView() {
        super.loadView()
        self.bindViewModels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setStackView()
        self.setAddTarget()
        self.setLayout()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .blackAlpha
        self.popupView.backgroundColor = .white
        self.popupView.layer.cornerRadius = 30
        self.popupView.addShadow(type: .black)
        
        self.badgeNameLabel.font = .semiBoldFont(ofSize: 20)
        self.badgeNameLabel.textColor = .black
        self.badgeNameLabel.textAlignment = .center
        
        self.badgeDescriptionLabel.font = .mediumFont(ofSize: 14)
        self.badgeDescriptionLabel.textColor = .gray100
        self.badgeDescriptionLabel.numberOfLines = 0
        self.badgeDescriptionLabel.setLineHeight(lineHeightMultiple: 1.25)
        self.badgeDescriptionLabel.textAlignment = .center
    }
    
    private func setStackView() {
        self.badgeConditionStack.axis = .vertical
        self.badgeConditionStack.distribution = .fill
        self.badgeConditionStack.spacing = 8
    }
    
    private func setLayout() {
        self.view.addSubview(popupView)
        
        popupView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(self.popupView.snp.width).multipliedBy(1.42)
            make.center.equalToSuperview()
        }
        
        self.popupView.addSubviews([badgeImageView, badgeNameLabel, badgeConditionStack,
                                    badgeDescriptionLabel, badgeButton])
        
        badgeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.width.height.equalTo(140)
        }
        
        badgeNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(badgeImageView.snp.bottom).offset(3)
        }
        
        badgeDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(badgeNameLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        badgeConditionStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(badgeNameLabel.snp.bottom).offset(102)
            make.leading.trailing.equalToSuperview().inset(13)
        }
        
        badgeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Methods
    
    func setBadgeData(data: BadgeDetailModel) {
        self.badgeNameLabel.text = data.name
        self.badgeDescriptionLabel.text = data.description
        self.badgeDescriptionLabel.setLineHeight(lineHeightMultiple: 1.25)
        self.badgeDescriptionLabel.textAlignment = .center
        self.badgeImageView.updateServerImage(data.imageUrl)
        
        if data.isEquipped {
            self.badgeButton.setTitle(I18N.Button.badgeOff, for: .normal)
        } else if data.isIssued {
            self.badgeButton.setTitle(I18N.Button.badgeOn, for: .normal)
            self.badgeButton.changeState(.abled)
        } else {
            self.badgeButton.changeState(.abled)
            self.badgeDescriptionLabel.text = I18N.My.noBadge
            self.badgeDescriptionLabel.font = .regularFont(ofSize: 12)
            self.badgeDescriptionLabel.setLineHeight(lineHeightMultiple: 1.08)
            self.badgeDescriptionLabel.textAlignment = .center
            self.badgeDescriptionLabel.textColor = .subOrange
        }
        
        for condition in data.condition {
            guard let title = condition[0] else { return }
            guard let count = condition[1] else { return }
            let badgeConditionView = BadgeConditionView(condition: title, count: count)
            badgeConditionStack.addArrangedSubviews([badgeConditionView, badgeConditionView])
        }
    }
    
    private func setAddTarget() {
        self.badgeButton.addTarget(self, action: #selector(dismissBadgeDetailVC), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissBadgeDetailVC))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    private func bindViewModels() {
        let input = BadgeDetailViewModel.Input(viewDidLoadEvent: self.rx.methodInvoked(#selector(UIViewController.viewDidLoad)).map { _ in })
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.badgeDetailModel
            .compactMap { $0 }
            .subscribe { [weak self] model in
                guard let data = model.element else { return }
                self?.setBadgeData(data: data)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - @objc
    
    @objc
    private func dismissBadgeDetailVC() {
        self.dismiss(animated: true)
    }
}
