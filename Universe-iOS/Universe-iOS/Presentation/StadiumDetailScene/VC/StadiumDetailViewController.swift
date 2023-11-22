//
//  StadiumDetailViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/16.
//

import SnapKit
import Then
import UIKit
import UniverseKit
import RxSwift
import RxRelay
import RxCocoa

class StadiumDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: StadiumDetailViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    private var stadiumData: StadiumDetailModel?
    var isIng: Bool = false
    var stadiumId: Int? = 3
    
    // MARK: - UI Components
    
    private let naviView = UIView().then {
        $0.backgroundColor = .clear
    }
    private var navigationBar = CustomNavigationBar()
    private var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    private var scrollViewContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleToFill
    }
    private let thumbnailCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
        $0.scrollDirection = .horizontal
    }
    private lazy var thumbnailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: thumbnailCollectionViewFlowLayout).then {
        $0.isPagingEnabled = true
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }
    private var pageControl = UIPageControl().then {
        $0.numberOfPages = 5
        $0.pageIndicatorTintColor = .lightGray100
        $0.currentPageIndicatorTintColor = .lightGreen
    }
    private var stadiumLabel = UILabel().then {
        $0.font = .boldFont(ofSize: 22)
        $0.textColor = .black
    }
    private var stadiumInfoLabel = UILabel().then {
        $0.addLineSpacing(spacing: 3)
        $0.font = .regularFont(ofSize: 14)
        $0.textColor = .gray100
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    private let mapIcon = UIImageView().then {
        $0.image = Icon.icPinPlace.image
    }
    private var addressLabel = UILabel().then {
        $0.font = .regularFont(ofSize: 14)
        $0.textColor = .gray100
        $0.sizeToFit()
    }
    private var mapButton = UIButton().then {
        $0.setTitle(I18N.Button.toMap, for: .normal)
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.titleLabel?.font = .semiBoldFont(ofSize: 14)
    }
    private let firstDividerLine = UIView().then {
        $0.backgroundColor = .lightGray200
    }
    private let courtsCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
    }
    private lazy var courtsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: courtsCollectionViewFlowLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    private let dimmedView = UIImageView().then {
        $0.image = Icon.bgWhiteGradient.image
    }
    private lazy var moreCourtButton = CustomButton(title: I18N.Button.moreCourt,
                                               type: .normal,
                                               size: .large).then {
        $0.addTarget(self, action: #selector(presentMoreStadiums), for: .touchUpInside)
    }
    private let secondDividerLine = UIView().then {
        $0.backgroundColor = .lightGray200
    }
    private let ceoTitleLabel = UILabel().then {
        $0.text = "사업자 정보"
        $0.font = .semiBoldFont(ofSize: 18)
        $0.textColor = .black
    }
    private var ceoInfoLabel = UILabel().then {
        $0.addLineSpacing(spacing: 6)
        $0.font = .regularFont(ofSize: 14)
        $0.textColor = .gray100
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    private let startButton = CustomButton(title: I18N.Play.startPlay,
                                                type: .abled,
                                                size: .large)
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavibars()
        setLayout()
        setDelegate()
        setRegister()
        setObservers()
        bindViewModels()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
}

extension StadiumDetailViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.startButton.addTarget(self, action: #selector(presentAddPlayers), for: .touchUpInside)
    }
    
    private func setData() {
        stadiumLabel.text = stadiumData?.name
        stadiumInfoLabel.text = stadiumData?.description
        addressLabel.text = stadiumData?.address
        ceoInfoLabel.text = "사업자 \(stadiumData?.businessName ?? "")\n대표자 \(stadiumData?.ceoName ?? "")\n연락처 \(stadiumData?.contact ?? "")"
        if (stadiumData?.indoorCourts.count ?? 0) + (stadiumData?.outdoorCourts.count ?? 0) < 4 {
            moreCourtButton.isHidden = true
            dimmedView.isHidden = true
        }
        
        if isIng {
            startButton.setTitle(I18N.Play.enter, for: .normal)
            startButton.changeState(.normal)
        } else {
            startButton.setTitle(I18N.Play.startGame, for: .normal)
        }
        
    }
    
    private func setNavibars() {
        navigationBar.setNavibar(self, title: "", type: .withBackButton)
        navigationBar.setTintColor(.white)
    }
    
    private func setLayout() {
        view.addSubviews([scrollView, naviView, navigationBar])
        scrollView.add(scrollViewContainerView)
        scrollViewContainerView.addSubviews([thumbnailCollectionView, pageControl, stadiumLabel,
                                             stadiumInfoLabel, mapIcon, addressLabel, mapButton,
                                             courtsCollectionView, firstDividerLine, dimmedView, moreCourtButton, secondDividerLine, ceoTitleLabel, ceoInfoLabel, startButton])
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.leading.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        scrollViewContainerView.snp.makeConstraints { make in
            make.centerX.top.leading.equalToSuperview()
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(view)
            make.height.equalTo(view.snp.height).priority(.low)
        }
        navigationBar.snp.makeConstraints { make in
            make.top.centerX.leading.equalTo(view.safeAreaLayoutGuide)
        }
        naviView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.leading.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(navigationBar.snp.top)
        }
        thumbnailCollectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.leading.equalToSuperview()
            make.height.equalTo(274)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(thumbnailCollectionView.snp.bottom).inset(14)
            make.height.equalTo(6)
        }
        stadiumLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailCollectionView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(17)
        }
        stadiumInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(stadiumLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(17)
        }
        mapIcon.snp.makeConstraints { make in
            make.top.equalTo(stadiumInfoLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(13)
        }
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mapIcon.snp.centerY)
            make.leading.equalTo(mapIcon.snp.trailing).offset(3)
        }
        mapButton.snp.makeConstraints { make in
            make.centerY.equalTo(mapIcon.snp.centerY)
            make.leading.equalTo(addressLabel.snp.trailing).offset(8)
        }
        firstDividerLine.snp.makeConstraints { make in
            make.top.equalTo(mapIcon.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(8)
        }
        courtsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(firstDividerLine.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(17)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(433)
        }
        dimmedView.snp.makeConstraints { make in
            make.bottom.equalTo(courtsCollectionView.snp.bottom)
            make.centerX.leading.equalToSuperview()
            make.height.equalTo(145)
        }
        moreCourtButton.snp.makeConstraints { make in
            make.bottom.equalTo(courtsCollectionView.snp.bottom)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(58)
        }
        secondDividerLine.snp.makeConstraints { make in
            make.top.equalTo(courtsCollectionView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(8)
        }
        ceoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(secondDividerLine.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(17)
        }
        ceoInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(ceoTitleLabel.snp.bottom).offset(11)
            make.leading.equalToSuperview().offset(17)
        }
        startButton.snp.makeConstraints { make in
            make.top.equalTo(ceoInfoLabel.snp.bottom).offset(30)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Methods
    
    private func setDelegate() {
        scrollView.delegate = self
        courtsCollectionView.delegate = self
        courtsCollectionView.dataSource = self
    }
    
    private func setRegister() {
        thumbnailCollectionView.register(StadiumDetailCVC.self, forCellWithReuseIdentifier: StadiumDetailCVC.className)
        courtsCollectionView.register(CourtHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CourtHeader.className)
        courtsCollectionView.register(CourtCVC.self, forCellWithReuseIdentifier: CourtCVC.className)
    }
    
    private func setObservers() {
        self.addObserverAction(.presentPlayVC) { [weak self] noti in
            guard let self = self else { return }
            guard let userInfo = noti.userInfo else { return }
            guard let matchId = userInfo["matchId"] as? Int else { return }
            
            self.hidesBottomBarWhenPushed = true
            
            self.isIng = true
            self.startButton.setTitle(I18N.Play.enter, for: .normal)
            self.startButton.changeState(.normal)
            
            if let matchInfo = userInfo["matchInfo"] as? MatchInfoModel,
            let matchScore = userInfo["matchScore"] as? MatchScoreModel {
                // 앞의 데이터를 갖고 전달 (입장, 경기 시작)
                print("🥲StadiumDetailVC - matchId:", matchId, matchInfo.homePlayer, matchInfo.awayPlayer)
                let playVC = self.moduleFactory.makePlayVC(.live, type: .enableControl, matchId: matchId, matchInfo: matchInfo, matchScore: matchScore)
                self.navigationController?.pushViewController(playVC, animated: true)
            } else {
                // 푸시알림을 통해 전달
                let playVC = self.moduleFactory.makePlayVC(.live, type: .enableControl, matchId: matchId)
                self.navigationController?.pushViewController(playVC, animated: true)
            }
        }
    }
    
    private func removeObservers() {
        self.removeObserverAction(.presentPlayVC)
    }
    
    private func bindViewModels() {
        let input = StadiumDetailViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).withUnretained(self).map { owner, _ in
            return owner.stadiumId ?? 1
        })
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)

        output.stadiumData
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                owner.stadiumData = model
                owner.setData()
                owner.courtsCollectionView.reloadData()
            }.disposed(by: self.disposeBag)
        
        output.stadiumThumbnails
            .bind(to: thumbnailCollectionView.rx.items(cellIdentifier: StadiumDetailCVC.className, cellType: StadiumDetailCVC.self)) { _, model, cell in
                cell.setImageData(model)
            }
            .disposed(by: disposeBag)
        
        thumbnailCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: - @objc
    
    @objc
    private func presentAddPlayers() {
        let addPlayerVC = moduleFactory.makeAddPlayerVC(isPlaying: isIng, matchId: stadiumData?.matchID, stadiumId: stadiumId, stadiumName: stadiumLabel.text ?? "")
        self.present(addPlayerVC, animated: true)
    }
    
    @objc
    private func presentMoreStadiums() {
        moreCourtButton.isHidden = true
        dimmedView.isHidden = true
        setCollectionHeight(collectionView: courtsCollectionView)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut,
          animations: courtsCollectionView.layoutIfNeeded, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StadiumDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 32
        var height: CGFloat = 50
        
        switch collectionView {
        case courtsCollectionView:
            if section == 0 {
                if (stadiumData?.indoorCourts.count ?? 0) == 0 {
                    height = 0
                }
            } else {
                if (stadiumData?.outdoorCourts.count ?? 0) == 0 {
                    height = 0
                }
            }
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = UIScreen.main.bounds.width
        var height: CGFloat = thumbnailCollectionView.frame.height
        
        switch collectionView {
        case thumbnailCollectionView:
            height = 274
        default:
            width = courtsCollectionView.frame.width - 7
            height = 80
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case thumbnailCollectionView:
            return 0
        default:
            return 11
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var edgeInsets: UIEdgeInsets
        switch collectionView {
        case thumbnailCollectionView:
            edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            edgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        }
        
        return edgeInsets
    }
}

// MARK: - UICollectionViewDataSource

extension StadiumDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case courtsCollectionView:
            return 2
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let courtHeader = courtsCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CourtHeader.className, for: indexPath) as? CourtHeader else { return UICollectionReusableView()}
        if collectionView == courtsCollectionView {
            switch indexPath.section {
            case 0:
                courtHeader.setData(.indoor)
            default:
                courtHeader.setData(.outdoor)
            }
        }
        return courtHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case thumbnailCollectionView:
            return stadiumData?.stadiumImageUrls.count ?? 0
        case courtsCollectionView:
            switch section {
            case 0:
                return stadiumData?.indoorCourts.count ?? 0
            case 1:
                return stadiumData?.outdoorCourts.count ?? 0
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case courtsCollectionView:
            guard let courtCell = collectionView.dequeueReusableCell(withReuseIdentifier: CourtCVC.className, for: indexPath) as? CourtCVC else { return UICollectionViewCell()}
            if indexPath.section == 0 && stadiumData?.indoorCourts != nil {
                courtCell.setData((stadiumData?.indoorCourts[indexPath.row])!, number: indexPath.row + 1)
            } else if indexPath.section == 1 && stadiumData?.outdoorCourts != nil {
                courtCell.setData((stadiumData?.outdoorCourts[indexPath.row])!, number: indexPath.row + 1)
            }
            
            return courtCell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UIScrollViewDelegate

extension StadiumDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollView {
            let location = scrollView.contentOffset.y
            switch location {
            case 300...:
                naviView.backgroundColor = .white
                navigationBar.setTitle(stadiumData?.name ?? "")
                navigationBar.setTintColor(.black)
                navigationBar.backgroundColor = .white
            default:
                navigationBar.setTitle("")
                navigationBar.setTintColor(.white)
                naviView.backgroundColor = UIColor.white.withAlphaComponent(location/350)
                navigationBar.backgroundColor = UIColor.white.withAlphaComponent(location/350)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == thumbnailCollectionView {
            let currentPage = Int(thumbnailCollectionView.contentOffset.x) / Int(thumbnailCollectionView.frame.width)
            pageControl.currentPage = currentPage
        }
    }
}
