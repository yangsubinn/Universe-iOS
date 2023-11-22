//
//  CommunityViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/03.
//

import Then
import UIKit
import UniverseKit
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

class CommunityViewController: BaseViewController {

    // MARK: - Properties
    
    var viewModel: CommunityViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    var ingLiveList: [CommunityModel] = []
    var replayLiveList: [CommunityModel] = []
    
    // MARK: - UI Components
    
    private let leagueImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.image = Icon.imgLeagueDimmed.image
    }
    private let commingSoonLabel = UILabel().then {
        $0.text = "Comming Soon!"
        $0.textColor = .lightGreen
        $0.font = .boldFont(ofSize: 30)
    }
    private let leagueInfoLabel = UILabel().then {
        $0.font = .mediumFont(ofSize: 14)
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    private let ingLiveHeaderView = LiveHeader(.ingLive)
    private let replayLiveHeaderView = LiveHeader(.ReplayLive)
    private let ingLivecollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    private let replayLivecollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var ingLivecollectionView = UICollectionView(frame: .zero, collectionViewLayout: ingLivecollectionViewFlowLayout).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
    }
    private lazy var replayLivecollectionView = UICollectionView(frame: .zero, collectionViewLayout: replayLivecollectionViewFlowLayout).then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.clipsToBounds = false
    }
    
    private let ingEmptyView = EmptyCVC(playType: .live)
    private let replayEmptyView = EmptyCVC(playType: .replay)
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setLeagueInfoLabel(leagueName: I18N.Community.leagueName,
                           leagueLocation: I18N.Community.leagueLocation,
                           leagueDate: I18N.Community.leagueDate)
        setHeaders()
        setRegister()
        bindViewModels()
    }
}

extension CommunityViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.setNavigationBar(title: "커뮤니티", type: .center)
        self.setTitleView(title: "커뮤니티")
    }
    
    private func setLeagueInfoLabel(leagueName: String, leagueLocation: String, leagueDate: String) {
        leagueInfoLabel.text = "\(leagueName)\n\(leagueLocation)\n\(leagueDate)"
        leagueInfoLabel.addLineSpacing(spacing: 3)
        leagueInfoLabel.textAlignment = .center
        leagueInfoLabel.setTargetAttrubutedTexts(targetStrings: [leagueLocation, leagueDate],
                                                 fontType: .medium, fontSize: 10, color: .white)
    }
    
    private func setHeaders() {
        ingLiveHeaderView.pushViewController = { [weak self] in
            guard let self = self else { return }
            let moreLiveVC = self.moduleFactory.makeMoreLiveVC(allLives: self.ingLiveList, liveType: .ingLive)
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(moreLiveVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
        replayLiveHeaderView.pushViewController = { [weak self] in
            guard let self = self else { return }
            let moreLiveVC = self.moduleFactory.makeMoreLiveVC(allLives: self.replayLiveList, liveType: .ReplayLive)
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(moreLiveVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }
    
    private func setLayout() {
        scrollViewContainerView.addSubviews([leagueImageView, ingLiveHeaderView, ingLivecollectionView,
                                             replayLiveHeaderView, replayLivecollectionView,
                                            ingEmptyView, replayEmptyView])
        leagueImageView.addSubviews([commingSoonLabel, leagueInfoLabel])
        
        leagueImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
        commingSoonLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(56)
        }
        leagueInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(commingSoonLabel.snp.bottom).offset(5)
        }
        ingLiveHeaderView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(leagueImageView.snp.bottom).offset(14)
            make.leading.equalToSuperview()
        }
        ingLivecollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ingLiveHeaderView.snp.bottom)
            make.leading.equalToSuperview()
            make.height.equalTo(230)
        }
        ingEmptyView.snp.makeConstraints { make in
            make.top.bottom.equalTo(ingLivecollectionView)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        replayLiveHeaderView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ingLivecollectionView.snp.bottom).offset(14)
            make.leading.equalToSuperview()
        }
        replayLivecollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(replayLiveHeaderView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(104)
        }
        replayEmptyView.snp.makeConstraints { make in
            make.top.bottom.equalTo(replayLivecollectionView)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func setRegister() {
        ingLivecollectionView.register(IngLiveCVC.self, forCellWithReuseIdentifier: IngLiveCVC.className)
        replayLivecollectionView.register(ReplayLiveCVC.self, forCellWithReuseIdentifier: ReplayLiveCVC.className)
    }
    
    private func bindViewModels() {
        let input = CommunityViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.ingLiveList
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                owner.ingEmptyView.isHidden = model.isEmpty ? false : true
                owner.ingLiveList = model
            }.disposed(by: self.disposeBag)
        
        output.replayList
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                owner.replayEmptyView.isHidden = model.isEmpty ? false : true
                owner.replayLiveList = model
            }.disposed(by: self.disposeBag)
        
        output.ingLiveList
            .map { $0.enumerated().filter({ $0.offset < 5 }).map { $0.element }}
            .bind(to: ingLivecollectionView.rx.items(cellIdentifier: IngLiveCVC.className, cellType: IngLiveCVC.self)) {[weak self] _, model, cell in
                guard let self = self else { return }
                self.ingEmptyView.isHidden = true
                cell.setData(model)
            }
            .disposed(by: disposeBag)
        
        output.replayList
            .map { $0.enumerated().filter({ $0.offset < 5 }).map { $0.element }}
            .bind(to: replayLivecollectionView.rx.items(cellIdentifier: ReplayLiveCVC.className, cellType: ReplayLiveCVC.self)) { [weak self] _, model, cell in
                guard let self = self else { return }
                self.replayEmptyView.isHidden = true
                cell.setData(model)
                self.setCollectionHeight(collectionView: self.replayLivecollectionView)
            }
            .disposed(by: disposeBag)
        
        ingLivecollectionView.rx.modelSelected(CommunityModel.self)
            .subscribe { [weak self] model in
                guard let self = self else { return }
                if let game = model.element {
                    let playVC = self.moduleFactory.makePlayVC(.live, type: .disableControl, matchId: game.matchID)
                    self.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(playVC, animated: true)
                    self.hidesBottomBarWhenPushed = false
                }
            }.disposed(by: disposeBag)
        
        replayLivecollectionView.rx.modelSelected(CommunityModel.self)
            .subscribe { [weak self] model in
                guard let self = self else { return }
                if let game = model.element {
                    let playVC = self.moduleFactory.makePlayVC(.replay, type: .disableControl, matchId: game.matchID)
                    self.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(playVC, animated: true)
                    self.hidesBottomBarWhenPushed = false
                }
            }.disposed(by: disposeBag)
        
        ingLivecollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        replayLivecollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommunityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = UIScreen.main.bounds.width - 32
        var height: CGFloat = 0
        
        switch collectionView {
        case ingLivecollectionView:
            width = 250
            height = 220
        case replayLivecollectionView:
            height = 104
        default:
            print()
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        switch collectionView {
        case ingLivecollectionView:
            edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 11)
        case replayLivecollectionView:
            edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 26, right: 16)
        default:
            print()
        }
        return edgeInsets
        
    }
}
