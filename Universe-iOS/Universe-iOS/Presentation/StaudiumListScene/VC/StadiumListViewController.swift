//
//  StadiumListViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/03.
//

import Then
import UIKit
import UniverseKit
import RxSwift
import RxRelay
import RxCocoa

class StadiumListViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: StadiumViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    private var ingStadium: StadiumModel?
    private var stadiumList: [StadiumModel] = []
    
    // MARK: - UI Components
    
    private let gamesCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
    }
    private lazy var gamesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: gamesCollectionViewFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.clipsToBounds = false
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        setRegister()
        bindViewModels()
        setObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
}

extension StadiumListViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.setNavigationBar(title: "경기장", type: .center)
        self.setTitleView(title: "경기장")
    }
    
    private func setLayout() {
        scrollViewContainerView.addSubview(gamesCollectionView)
        
        gamesCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    private func setDelegate() {
        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
    }
    
    private func setRegister() {
        gamesCollectionView.register(IngGameHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IngGameHeader.className)
        gamesCollectionView.register(StadiumCVC.self, forCellWithReuseIdentifier: StadiumCVC.className)
    }
    
    private func setObservers() {
        self.addObserverAction(.pushNotiTapped) { [weak self] noti in
            guard let self = self else { return }
            if let matchId = noti.userInfo?["matchId"] as? Int {
                let playVC = self.moduleFactory.makePlayVC(.live, type: .enableControl, matchId: matchId)
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(playVC, animated: true)
                self.hidesBottomBarWhenPushed = false
            }
        }
    }
    
    private func removeObservers() {
        self.removeObserverAction(.pushNotiTapped)
    }
    
    private func bindViewModels() {
        let input = StadiumViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        // TODO: - 약한 참조
        output.ingStadium
            .subscribe { model in
                self.ingStadium = model
                self.gamesCollectionView.reloadData()
                self.gamesCollectionViewFlowLayout.invalidateLayout()
            }.disposed(by: self.disposeBag)
        
        output.stadiumLists
            .compactMap { $0 }
            .subscribe { model in
                self.stadiumList = model
                self.gamesCollectionView.reloadData()
                self.gamesCollectionViewFlowLayout.invalidateLayout()
            }.disposed(by: self.disposeBag)
    }
    
    @objc
    private func presentStadiumDetailVC() {
        self.hidesBottomBarWhenPushed = true
        let stadiumDetailVC = self.moduleFactory.makeStadiumDetailVC(isIng: true, stadiumId: ingStadium?.id)
        self.navigationController?.pushViewController(stadiumDetailVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

// MARK: - UICollectionViewDelegate
extension StadiumListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.hidesBottomBarWhenPushed = true
        let stadiumId = stadiumList[indexPath.row].id
        let stadiumDetailVC = moduleFactory.makeStadiumDetailVC(isIng: false, stadiumId: stadiumId)
        self.navigationController?.pushViewController(stadiumDetailVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StadiumListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 32
        var height: CGFloat = 200
        
        if ingStadium == nil {
            height = 0
        } else {
            height = 200
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 32
        let height: CGFloat = 80
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 9, right: 0)

        return edgeInsets
    }
}

// MARK: - UICollectionViewDataSource

extension StadiumListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let ingGameHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IngGameHeader.className, for: indexPath) as? IngGameHeader else { return UICollectionReusableView()}
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentStadiumDetailVC))
        ingGameHeader.addGestureRecognizer(tap)
        if ingStadium != nil {
            ingGameHeader.setData(ingStadium!)
        }

        return ingGameHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stadiumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.stadiumList
        guard let stadiumCell = collectionView.dequeueReusableCell(withReuseIdentifier: StadiumCVC.className, for: indexPath) as? StadiumCVC else { return UICollectionViewCell()}
        stadiumCell.setData(model[indexPath.row])
        return stadiumCell
    }
}
