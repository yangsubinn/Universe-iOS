//
//  MoreLiveViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/09.
//

import Then
import UIKit
import UniverseKit
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

final class MoreLiveViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: CommunityViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    var contentModel: [CommunityModel] = []
    var liveType: LiveType?

    // MARK: - UI Components
    
    private var navigationBar = CustomNavigationBar()
    private let ingLivecollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
    }
    private lazy var ingLivecollectionView = UICollectionView(frame: .zero, collectionViewLayout: ingLivecollectionViewFlowLayout).then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.clipsToBounds = false
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        setRegister()
    }

}

extension MoreLiveViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        switch liveType {
        case .ingLive:
            navigationBar.setNavibar(self, title: I18N.Community.ingLive, type: .withBackButton)
        case .ReplayLive:
            navigationBar.setNavibar(self, title: I18N.Community.replayLive, type: .withBackButton)
        default:
            navigationBar.setNavibar(self, title: "", type: .withBackButton)
        }
        
        navigationBar.setTitleAttribute(target: "LIVE", .subOrange)
    }
    
    private func setLayout() {
        view.addSubviews([navigationBar, ingLivecollectionView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.centerX.leading.equalTo(self.view.safeAreaLayoutGuide)
        }
        ingLivecollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func setDelegate() {
        ingLivecollectionView.delegate = self
        ingLivecollectionView.dataSource = self
    }
    
    private func setRegister() {
        ingLivecollectionView.register(ReplayLiveCVC.self, forCellWithReuseIdentifier: ReplayLiveCVC.className)
    }
}

// MARK: - UICollectionViewDelegate

extension MoreLiveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playVC = self.moduleFactory.makePlayVC(.replay, type: .disableControl, matchId: contentModel[indexPath.row].matchID)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(playVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MoreLiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 32
        let height: CGFloat = 104
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
}

// MARK: - UICollectionViewDataSource

extension MoreLiveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let replayLiveCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReplayLiveCVC.className, for: indexPath) as? ReplayLiveCVC else { return UICollectionViewCell()}
        
        replayLiveCell.setData(contentModel[indexPath.row])
        return replayLiveCell
    }
}
