//
//  MatchAnalysisViewController.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/16.
//

import UIKit
import UniverseKit
import RxSwift
import RxRelay
import RxCocoa

class MatchAnalysisViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: MatchAnalysisViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let naviBar = CustomNavigationBar()
    private let matchCollectioinViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var matchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: matchCollectioinViewFlowLayout)
    
    // MARK: - View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setRegister()
        setDelegate()
        bindViewModels()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        naviBar.setNavibar(self, title: I18N.Analysis.matchAnalysis, type: .withBackButton)
        matchCollectionView.clipsToBounds = false
    }
    
    private func setLayout() {
        self.view.addSubviews([naviBar, matchCollectionView])
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        matchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    private func setRegister() {
        matchCollectionView.register(ReplayLiveCVC.self, forCellWithReuseIdentifier: ReplayLiveCVC.className)
    }
    
    private func setDelegate() {
        matchCollectionView.delegate = self
        
        matchCollectionView.rx.modelSelected(CommunityModel.self)
            .subscribe { [weak self] model in
                guard let self = self else { return }
                if let game = model.element {
                    let playVC = self.moduleFactory.makePlayVC(.replay, type: .disableControl, matchId: game.matchID)
                    self.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(playVC, animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindViewModels() {
        let input = MatchAnalysisViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
        let output = self.viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.myPlayList
            .bind(to: matchCollectionView.rx.items(cellIdentifier: ReplayLiveCVC.className, cellType: ReplayLiveCVC.self)) { _, item, cell in
                cell.setData(item)
            }.disposed(by: disposeBag)
    }
}

extension MatchAnalysisViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 32
        let height: CGFloat = 104.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 11, left: 0, bottom: 34, right: 0)
    }
}
