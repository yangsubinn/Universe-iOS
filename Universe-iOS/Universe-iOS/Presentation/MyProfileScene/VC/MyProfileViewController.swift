//
//  MyProfileViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/03.
//

import UIKit
import UniverseKit
import RxSwift
import RxRelay
import RxCocoa

class MyProfileViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: MyProfileViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    private let contentList = [ProfileCVC.className, BadgeCVC.className,
                               PlanCVC.className, I18N.My.notice,
                               I18N.My.service, I18N.My.partnership,
                               I18N.My.logout]
    private var contentModel: MyProfileModel?
    private var badgeModel: BadgeListModel?
    
    // MARK: - UI Components
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.setRegister()
        self.bindViewModels()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.setNavigationBar(title: "MY", type: .center)
        self.setTitleView(title: "MY")
        self.collectionView.isScrollEnabled = false
    }
    
    private func setLayout() {
        self.scrollViewContainerView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.titleView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(collectionView.contentSize.height)
        }
    }
    
    // MARK: - Methods
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func setRegister() {
        self.collectionView.register(HeaderCVC.self, forCellWithReuseIdentifier: HeaderCVC.className)
        self.collectionView.register(ProfileCVC.self, forCellWithReuseIdentifier: ProfileCVC.className)
        self.collectionView.register(BadgeCVC.self, forCellWithReuseIdentifier: BadgeCVC.className)
        self.collectionView.register(PlanCVC.self, forCellWithReuseIdentifier: PlanCVC.className)
        self.collectionView.register(MyDefaultCVC.self, forCellWithReuseIdentifier: MyDefaultCVC.className)
        self.collectionView.register(LogoutCVC.self, forCellWithReuseIdentifier: LogoutCVC.className)
    }
    
    private func bindViewModels() {
        let input = MyProfileViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.myProfileModel
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                owner.contentModel = model
                owner.collectionView.reloadData()
            }.disposed(by: self.disposeBag)
        
        output.badgeListModel
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                owner.badgeModel = model
                owner.collectionView.reloadData()
                owner.setCollectionHeight(collectionView: owner.collectionView)
            }.disposed(by: self.disposeBag)
        
        output.error
            .compactMap { $0 as? APIError }
            .withUnretained(self)
            .subscribe { owner, error in
                owner.showErrorAlert(errortype: error)
            }.disposed(by: self.disposeBag)
    }
    
    private func removeUserDefaults(completion: @escaping (() -> Void)) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: Const.UserDefaultsKey.accessToken)
        userDefaults.removeObject(forKey: Const.UserDefaultsKey.userId)
        completion()
    }
    
    private func moveToLoginVC() {
        let loginVC = self.moduleFactory.makeLoginVC()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = windowScene.windows.first else { return }
        window.rootViewController = UINavigationController(rootViewController: loginVC)
        loginVC.showToast(message: I18N.My.logoutSuccess, bottom: 70)
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension MyProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.hidesBottomBarWhenPushed = true
            let badgeVC = moduleFactory.makeMyBadgeVC()
            self.navigationController?.pushViewController(badgeVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        case 2:
            self.hidesBottomBarWhenPushed = true
            let planVC = moduleFactory.makePlanVC()
            self.navigationController?.pushViewController(planVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        case 6:
            removeUserDefaults { [weak self] in
                self?.moveToLoginVC()
            }
        default:
            print("etc")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 32
        var height: CGFloat = 0
        
        switch indexPath.row {
        case 0:
            height = 170
        case 1:
            height = 91
        case 2:
            height = 125
        case 3, 4, 5, 6:
            height = 40
        default:
            height = 0
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 11, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UICollectionViewDataSource

extension MyProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let model = self.contentModel
            guard let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCVC.className, for: indexPath) as? ProfileCVC else { return UICollectionViewCell() }
            profileCell.setProfileData(profileImage: model?.profileImageURL, username: model?.userName ?? "", ntrp: model?.nrtp, manner: model?.manner ?? "", isPro: model?.isPro ?? false)
            return profileCell
        case 1:
            let model = self.badgeModel
            guard let badgeCell = collectionView.dequeueReusableCell(withReuseIdentifier: BadgeCVC.className, for: indexPath) as? BadgeCVC else { return UICollectionViewCell() }
            badgeCell.setData(model ?? [])
            return badgeCell
        case 2:
            let model = self.contentModel
            guard let planCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanCVC.className, for: indexPath) as? PlanCVC else { return UICollectionViewCell() }
            planCell.setData(plan: model?.plan ?? .basic)
            return planCell
        case 3, 4, 5:
            guard let myDefaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDefaultCVC.className, for: indexPath) as? MyDefaultCVC else { return UICollectionViewCell() }
            myDefaultCell.setData(contentList[indexPath.row])
            return myDefaultCell
        case 6:
            guard let logoutCell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoutCVC.className, for: indexPath) as? LogoutCVC else { return UICollectionViewCell() }
            logoutCell.setData(contentList[indexPath.row])
            return logoutCell
        default:
            return UICollectionViewCell()
        }
    }
}
