//
//  MyBadgeViewController.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/04.
//

import UIKit
import UniverseKit
import RxSwift
import RxCocoa
import RxRelay

class MyBadgeViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: MyBadgeViewModel!
    private let disposeBag = DisposeBag()
    private var badgeModelList: [BadgeModel] = []
    private let moduleFactory = ModuleFactory.shared
    
    // MARK: - UI Components
    
    private let naviBar = CustomNavigationBar()
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setRegister()
        self.bindViewModels()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.view.backgroundColor = .white
        naviBar.setNavibar(self, title: "My 뱃지", type: .withBackButton)
        collectionView.clipsToBounds = false
    }
    
    private func setLayout() {
        self.view.addSubviews([naviBar, collectionView])
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setRegister() {
        self.collectionView.register(WideBadgeCVC.self, forCellWithReuseIdentifier: WideBadgeCVC.className)
    }
    
    // MARK: - Methods
    
    func bindViewModels() {
        let input = MyBadgeViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
        let output = self.viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.badgeLists
            .bind(to: collectionView.rx.items(cellIdentifier: WideBadgeCVC.className, cellType: WideBadgeCVC.self)) { _, model, cell in
                cell.setData(model)
            }
            .disposed(by: disposeBag)
        
        output.error
            .compactMap { $0 as? APIError }
            .withUnretained(self)
            .subscribe { owner, error in
                owner.showErrorAlert(errortype: error)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(BadgeModel.self)
            .subscribe { [weak self] model in
                guard let self = self else { return }
                if let badge = model.element {
                    let badgeDetailVC = self.moduleFactory.makeBadgeDetailVC(badgeId: badge.id)
                    self.present(badgeDetailVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyBadgeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width-32
        let height = width*96/343
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
    }
}
