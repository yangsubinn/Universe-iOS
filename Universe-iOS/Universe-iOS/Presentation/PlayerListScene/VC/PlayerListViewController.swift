//
//  PlayerListViewController.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import UIKit
import UniverseKit
import RxSwift
import RxRelay
import RxCocoa

class PlayerListViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: PlayerListViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    private var playerList: [PlayerModel] = []
    var teamType: TeamType = .away
    weak var bottomSheetDelegate: BottomSheetDelegate?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModels()
        setLayout()
        setUI()
        setDelegate()
        setRegister()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        self.titleLabel.text = I18N.Play.enterPlayerInfo
        self.titleLabel.font = .semiBoldFont(ofSize: 18)
        self.titleLabel.textColor = .black
        self.titleLabel.textAlignment = .center
    }
    
    private func setLayout() {
        self.view.addSubviews([titleLabel, collectionView])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func setRegister() {
        self.collectionView.register(PlayerListCVC.self, forCellWithReuseIdentifier: PlayerListCVC.className)
    }
    
    private func bindViewModels() {
        let input = PlayerListViewModel.Input(viewWillAppearEvent: rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map { _ in })
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.playerListRelay
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, list in
                owner.setData(playerList: list)
            }.disposed(by: self.disposeBag)
    }
    
    func setData(playerList: [PlayerModel]) {
        self.playerList = playerList
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate

extension PlayerListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !playerList[indexPath.row].isSelected && !playerList[indexPath.row].isPlaying {
            bottomSheetDelegate?.dismissButtonTapped(completion: { [weak self] in
                guard let self = self else { return }
                self.postObserverAction(.dismissPlayerList,
                                        userInfo: ["team": self.teamType,
                                                   "userId": self.playerList[indexPath.row].userId])
            })
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlayerListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width
        let height = 58.0
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDataSource

extension PlayerListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerListCVC.className, for: indexPath) as? PlayerListCVC else { return UICollectionViewCell() }
        cell.setData(data: playerList[indexPath.row])
        return cell
    }
}
