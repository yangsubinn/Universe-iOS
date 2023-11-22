//
//  PlanViewController.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/05.
//

import UIKit
import UniverseKit

class PlanViewController: UIViewController {
    
    // MARK: - Properties
    
    private let planModelList: [PlanModel] = [PlanModel(title: I18N.Plan.basicPlan,
                                       composition: I18N.Plan.basicComposition,
                                       price: I18N.Plan.basicPrice),
                             PlanModel(title: I18N.Plan.standardPlan,
                                       composition: I18N.Plan.standardCompositon,
                                       price: I18N.Plan.standardPrice),
                             PlanModel(title: I18N.Plan.premiumPlan,
                                       composition: I18N.Plan.premiumComposition,
                                       price: I18N.Plan.premiumPrice)]
    private let paymentList: [PaymentType] = PaymentType.allCases
    private var selectedPlan: PlanType = .basic
    private var selectedPayment: PaymentType = .card
    
    // MARK: - UI Components
    
    private let naviBar = CustomNavigationBar()
    private let subscribeButton = CustomButton(title: I18N.Plan.subscribe, type: .disabled, size: .large)
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let planStackView = UIStackView()
    private lazy var basicPlanView = PlanView(planModel: planModelList[0])
    private lazy var standardPlanView = PlanView(planModel: planModelList[1])
    private lazy var premiumPlanView = PlanView(planModel: planModelList[2])
    private let paymentLabel = UILabel()
    private let paymentStackView = UIStackView()
    private lazy var cardPaymentButton = PaymentButton(paymentList[0].rawValue)
    private lazy var virtualPaymentButton = PaymentButton(paymentList[1].rawValue)
    private lazy var transferPaymentButton = PaymentButton(paymentList[2].rawValue)
    private let personalAgreeButton = UIButton(primaryAction: nil)
    private let personalMoreButton = UIButton()
    private let termAgreeButton = UIButton(primaryAction: nil)
    private let termMoreButton = UIButton()
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setStackView()
        self.setLayout()
        self.setSelectedPlan()
        self.setSelectedPayment()
        self.setAction()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.view.backgroundColor = .white
        self.naviBar.setNavibar(self, title: I18N.Plan.subscribeProduct, type: .withBackButton)
        
        self.paymentLabel.text = I18N.Plan.paymentMethod
        self.paymentLabel.textColor = .black
        self.paymentLabel.font = .mediumFont(ofSize: 16)
        
        if #available(iOS 15, *) {
            var container = AttributeContainer()
            container.font = .mediumFont(ofSize: 14)
            
            var configuration = UIButton.Configuration.plain()
            configuration.image = Icon.icCheckBox.image.withTintColor(.gray100)
            configuration.imagePadding = 5
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            configuration.baseForegroundColor = .black
            configuration.baseBackgroundColor = .clear
            
            let handler: UIButton.ConfigurationUpdateHandler = { button in
                button.configuration?.image = (button.isSelected == true) ? Icon.icCheckBox.image : Icon.icCheckBox.image.withTintColor(.gray100)
            }
            
            // personalAgreeButton
            configuration.attributedTitle = AttributedString(I18N.Plan.personalAgree, attributes: container)
            self.personalAgreeButton.configuration = configuration
            self.personalAgreeButton.configurationUpdateHandler = handler
            
            // termAgreeButton
            configuration.attributedTitle = AttributedString(I18N.Plan.termAgree, attributes: container)
            self.termAgreeButton.configuration = configuration
            self.termAgreeButton.configurationUpdateHandler = handler
        } else {
            personalAgreeButton.setTitle(I18N.Plan.personalAgree, for: .normal)
            termAgreeButton.setTitle(I18N.Plan.termAgree, for: .normal)
            
            [personalAgreeButton, termAgreeButton].forEach { button in
                button.setImage(Icon.icCheckBox.image.withTintColor(.gray100), for: .normal)
                button.setImage(Icon.icCheckBox.image, for: .selected)
                button.setTitleColor(.black, for: .normal)
                button.titleLabel?.font = .mediumFont(ofSize: 14)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            }
        }
        
        [termMoreButton, personalMoreButton].forEach { button in
            button.setTitle(I18N.Plan.seeMoreButton, for: .normal)
            button.setTitleColor(.gray100, for: .normal)
            button.titleLabel?.font = .mediumFont(ofSize: 12)
            button.setUnderline()
        }
    }
    
    private func setStackView() {
        self.planStackView.axis = .vertical
        self.planStackView.distribution = .fill
        self.planStackView.spacing = 11
        self.planStackView.addArrangedSubviews(basicPlanView, standardPlanView, premiumPlanView)
        
        self.paymentStackView.axis = .horizontal
        self.paymentStackView.distribution = .fillEqually
        self.paymentStackView.spacing = 14
        self.paymentStackView.addArrangedSubviews([cardPaymentButton, virtualPaymentButton, transferPaymentButton])
    }
    
    private func setLayout() {
        self.view.addSubviews([naviBar, scrollView, subscribeButton])
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(naviBar.snp.bottom)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
        }
        
        self.scrollView.addSubview(scrollContentView)
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.scrollContentView.addSubviews([planStackView, paymentLabel,
                                            paymentStackView, personalAgreeButton,
                                           personalMoreButton, termAgreeButton,
                                           termMoreButton])
        
        planStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(11)
        }
        
        paymentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(planStackView.snp.bottom).offset(24)
        }

        paymentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(paymentLabel.snp.bottom).offset(16)
        }
        
        personalAgreeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(paymentStackView.snp.bottom).offset(30)
        }
        
        personalMoreButton.snp.makeConstraints { make in
            make.centerY.equalTo(personalAgreeButton.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
        
        termAgreeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(personalAgreeButton.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(100)
        }
        
        termMoreButton.snp.makeConstraints { make in
            make.centerY.equalTo(termAgreeButton.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func setSelectedPlan() {
        switch self.selectedPlan {
        case .basic:
            self.basicPlanView.setUI(isSeleted: true)
            self.standardPlanView.setUI(isSeleted: false)
            self.premiumPlanView.setUI(isSeleted: false)
        case .standard:
            self.basicPlanView.setUI(isSeleted: false)
            self.standardPlanView.setUI(isSeleted: true)
            self.premiumPlanView.setUI(isSeleted: false)
        case .premium:
            self.basicPlanView.setUI(isSeleted: false)
            self.standardPlanView.setUI(isSeleted: false)
            self.premiumPlanView.setUI(isSeleted: true)
        }
    }
    
    private func setSelectedPayment() {
        switch self.selectedPayment {
        case .card:
            self.cardPaymentButton.setUI(isSeleted: true)
            self.virtualPaymentButton.setUI(isSeleted: false)
            self.transferPaymentButton.setUI(isSeleted: false)
        case .virtualAccount:
            self.cardPaymentButton.setUI(isSeleted: false)
            self.virtualPaymentButton.setUI(isSeleted: true)
            self.transferPaymentButton.setUI(isSeleted: false)
        case .accountTransfer:
            self.cardPaymentButton.setUI(isSeleted: false)
            self.virtualPaymentButton.setUI(isSeleted: false)
            self.transferPaymentButton.setUI(isSeleted: true)
        }
    }
    
    private func setAction() {
        let basicTap = UITapGestureRecognizer(target: self, action: #selector(tappedBasicPlan))
        let standardTap = UITapGestureRecognizer(target: self, action: #selector(tappedStandardPlan))
        let premiumTap = UITapGestureRecognizer(target: self, action: #selector(tappedPremiumPlan))
        self.basicPlanView.addGestureRecognizer(basicTap)
        self.standardPlanView.addGestureRecognizer(standardTap)
        self.premiumPlanView.addGestureRecognizer(premiumTap)
        
        let paymentAction = UIAction { [weak self] action in
            self?.changePayment(action.sender as! UIButton)
        }
        self.cardPaymentButton.addAction(paymentAction, for: .touchUpInside)
        self.virtualPaymentButton.addAction(paymentAction, for: .touchUpInside)
        self.transferPaymentButton.addAction(paymentAction, for: .touchUpInside)
        
        let agreeAction = UIAction { [weak self] action in
            self?.changeAgreeButtonState(action.sender as! UIButton)
        }
        self.personalAgreeButton.addAction(agreeAction, for: .touchUpInside)
        self.termAgreeButton.addAction(agreeAction, for: .touchUpInside)
    }
    
    private func changePayment(_ button: UIButton) {
        self.selectedPayment = PaymentType(rawValue: button.titleLabel?.text ?? "") ?? .card
        self.setSelectedPayment()
    }
    
    private func changeAgreeButtonState(_ button: UIButton) {
        button.isSelected = (button.isSelected == true) ? false : true
        
        if self.personalAgreeButton.isSelected && self.termAgreeButton.isSelected {
            self.subscribeButton.changeState(.abled)
        } else {
            self.subscribeButton.changeState(.disabled)
        }
    }
    
    // MARK: - @objc
    
    @objc
    private func tappedBasicPlan() {
        self.selectedPlan = .basic
        self.setSelectedPlan()
    }
    
    @objc
    private func tappedStandardPlan() {
        self.selectedPlan = .standard
        self.setSelectedPlan()
    }
    
    @objc
    private func tappedPremiumPlan() {
        self.selectedPlan = .premium
        self.setSelectedPlan()
    }
}
