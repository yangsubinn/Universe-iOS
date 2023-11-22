//
//  AnalysisViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/03.
//

import UIKit
import UniverseKit
import RxSwift
import RxCocoa
import RxRelay

class AnalysisViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: AnalysisViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    private var isDefaultTap: Bool = true
    private var myMatchId: Int?
    private var basicStatList: [StatModel] = []
    private var pointStatList: [[GraphModel]] = []
    
    // MARK: - UI Components
    
    private let profileView = ProfileCVC()
    private let matchAnalysisLabel = UILabel()
    private let moreButton = MoreButton(title: I18N.Default.more, font: .semiBoldFont(ofSize: 14), tintColor: .mainBlue)
    private let matchAnalysisView = MatchAnalysisView()
    private let defaultInfoButton = UIButton()
    private let pointInfoButton = UIButton()
    private lazy var buttons = [defaultInfoButton, pointInfoButton]
    private lazy var buttonStackView = UIStackView(arrangedSubviews: buttons)
    private let indicatorBackgroundView = UIView()
    private let indicatorView = UIView()
    private let indicatorWidth = NSLayoutConstraint()
    private let defaultCollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var defaultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: defaultCollectionViewFlowLayout)
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModels()
        setDelegate()
        setLayout()
        setRegister()
        bindActions()
    }

    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.setNavigationBar(title: I18N.Analysis.analysis, type: .center)
        self.setTitleView(title: I18N.Analysis.analysis)
        
        self.matchAnalysisLabel.text = I18N.Analysis.matchAnalysis
        self.matchAnalysisLabel.textColor = .black
        self.matchAnalysisLabel.font = .semiBoldFont(ofSize: 18)
        
        self.buttonStackView.axis = .horizontal
        self.buttonStackView.distribution = .fillEqually
        
        defaultInfoButton.setTitle(I18N.Analysis.defaultInfo, for: .normal)
        pointInfoButton.setTitle(I18N.Analysis.pointInfo, for: .normal)
        
        buttons.forEach {
            $0.setTitleColor(.black, for: .selected)
            $0.setTitleColor(.gray100, for: .normal)
            $0.titleLabel?.font = .mediumFont(ofSize: 14)
        }
        
        indicatorBackgroundView.backgroundColor = .grayAlpha
        indicatorView.backgroundColor = .mainBlue
        
        defaultCollectionView.isScrollEnabled = false
    }
    
    private func setLayout() {
        indicatorWidth.constant = (UIScreen.main.bounds.width - 32) / CGFloat(Float(buttons.count))
        
        self.scrollViewContainerView.addSubviews([profileView, matchAnalysisLabel,
                                                  moreButton, matchAnalysisView,
                                                  buttonStackView, indicatorBackgroundView,
                                                  indicatorView, defaultCollectionView])
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(self.titleView.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(170)
        }
        
        matchAnalysisLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(27)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(matchAnalysisLabel.snp.bottom)
        }
        
        matchAnalysisView.snp.makeConstraints { make in
            make.top.equalTo(matchAnalysisLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(104)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(matchAnalysisView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(34)
        }
        
        indicatorBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(buttonStackView)
            make.height.equalTo(2)
        }
        
        indicatorView.snp.remakeConstraints { make in
            make.leading.equalTo(16)
            make.bottom.equalTo(buttonStackView)
            make.width.equalTo(self.indicatorWidth.constant)
            make.height.equalTo(2)
        }
        
        defaultCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(myMatchId != nil ? 700 : 300)
            make.top.equalTo(buttonStackView.snp.bottom).offset(6)
        }
    }
    
    // MARK: - Methods
    
    private func setUserInfoData(data: AnalysisUserInfoModel) {
        profileView.isProflieTab = false
        profileView.setAnalysisData(profileImage: data.profileImageUrl, username: data.userName, ntrp: data.ntrp, playedYear: data.playedYear, age: data.age, gender: data.gender)
    }
    
    private func setPlayData(data: CommunityModel?) {
        if let data = data {
            myMatchId = data.matchID
            defaultCollectionView.snp.updateConstraints { make in
                make.height.equalTo(700)
            }
            defaultCollectionView.reloadData()
            matchAnalysisView.setData(date: data.matchStartTime,
                                      homeScore: data.homeWonGameCount,
                                      awayScore: data.awayWonGameCount,
                                      homeProfileImages: data.homeUserProfileImageUrls,
                                      awayProfileImages: data.awayUserProfileImageUrls,
                                      homeNicknames: data.homeUserNames,
                                      awayNicknames: data.awayUserNames,
                                      stadiumName: data.stadiumName)
        } else {
            matchAnalysisView.setEmptyView()
        }
    }
    
    private func setDelegate() {
        defaultCollectionView.delegate = self
        defaultCollectionView.dataSource = self
    }
    
    private func setRegister() {
        defaultCollectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.className)
        defaultCollectionView.register(SubtitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SubtitleHeaderView.className)
        defaultCollectionView.register(DefaultCVC.self, forCellWithReuseIdentifier: DefaultCVC.className)
        defaultCollectionView.register(DiagnosisCVC.self, forCellWithReuseIdentifier: DiagnosisCVC.className)
        defaultCollectionView.register(GraphCVC.self, forCellWithReuseIdentifier: GraphCVC.className)
    }
    
    private func bindActions() {
        moreButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.pushToMatchAnalysisVC()
            }.disposed(by: self.disposeBag)
        
        defaultInfoButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.tappedDefaultInfoButton()
            }.disposed(by: self.disposeBag)
        
        pointInfoButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.tappedPointInfoButton()
            }.disposed(by: self.disposeBag)

        matchAnalysisView.onTap { [weak self] in
            if let matchId = self?.myMatchId {
                self?.pushToPlayVC(matchId: matchId)
            }
        }
    }
    
    private func bindViewModels() {
        let input = AnalysisViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
        let output = self.viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.userInfoModel
            .compactMap { $0 }
            .subscribe { [weak self] model in
                self?.setUserInfoData(data: model)
            }.disposed(by: self.disposeBag)
        
        output.myPlayModel
            .subscribe { [weak self] model in
                self?.setPlayData(data: model)
            }.disposed(by: self.disposeBag)
        
        output.basicStatModel
            .compactMap { $0 }
            .subscribe { [weak self] model in
                self?.basicStatList = model.stats
                self?.defaultCollectionView.reloadData()
            }.disposed(by: self.disposeBag)
        
        output.pointStatModel
            .compactMap { $0 }
            .subscribe { [weak self] model in
                self?.pointStatList = model
                self?.defaultCollectionView.reloadData()
            }.disposed(by: self.disposeBag)
        
        output.error
            .subscribe({ [weak self] error in
                if let error = error.element as? APIError {
                    self?.showErrorAlert(errortype: error)
                } else {
                    self?.showNetworkAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func tappedDefaultInfoButton() {
        if !defaultInfoButton.isSelected {
            defaultInfoButton.isSelected = true
            pointInfoButton.isSelected = false
            moveIndicatorBarWithAnimation()
            
            isDefaultTap = true
            
            defaultCollectionView.reloadData()
            
            defaultCollectionView.snp.updateConstraints { make in
                make.height.equalTo(myMatchId != nil ? 700 : 300)
            }
        }
        
        scrollView.setContentOffset(CGPoint(x: 0, y: myMatchId != nil ? 420 : 100), animated: true)
    }
    
    private func tappedPointInfoButton() {
        if !pointInfoButton.isSelected {
            defaultInfoButton.isSelected = false
            pointInfoButton.isSelected = true
            moveIndicatorBarWithAnimation(constant: Float((UIScreen.main.bounds.width - 32)) / 2)
            
            isDefaultTap = false
            defaultCollectionView.reloadData()
            
            defaultCollectionView.snp.updateConstraints { make in
                make.height.equalTo(700)
            }
        }
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 420), animated: true)
    }
    
    private func moveIndicatorBarWithAnimation(constant: Float? = nil) {
        UIView.animate(withDuration: 0.2, delay: 0) {
            if let constant = constant {
                let transform = CGAffineTransform(translationX: CGFloat(constant), y: 0)
                self.indicatorView.transform = transform
            } else {
                self.indicatorView.transform = .identity
            }
        }
    }
    
    private func pushToMatchAnalysisVC() {
        self.hidesBottomBarWhenPushed = true
        let matchAnalysisVC = moduleFactory.makeMatchAnalysisVC()
        self.navigationController?.pushViewController(matchAnalysisVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    private func pushToPlayVC(matchId: Int) {
        self.hidesBottomBarWhenPushed = true
        let playVC = moduleFactory.makePlayVC(.replay, type: .disableControl, matchId: matchId)
        self.navigationController?.pushViewController(playVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

// MARK: - UICollectionViewDelegate

extension AnalysisViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        var height = 42.0
        
        if !isDefaultTap && section != 0 {
            height = 39.0
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isDefaultTap && section != 0 {
            return 11
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if isDefaultTap {
            return UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0)
        }
        
        if section != 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        } else {
            return UIEdgeInsets()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AnalysisViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width
        var height = 40.0
        
        if isDefaultTap {
            width -= 32
            if indexPath.section == 1 { height = 80.0 }
        } else {
            height = 50.0
        }
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectioinViewDataSource

extension AnalysisViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isDefaultTap {
            return myMatchId != nil ? 2 : 1
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if isDefaultTap {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.className, for: indexPath) as? TitleHeaderView else { return UICollectionReusableView() }
            header.setTitle(title: viewModel.titleHeaderList[indexPath.section])
            return header
        } else {
            if indexPath.section == 0 {
                guard let titleHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.className, for: indexPath) as? TitleHeaderView else { return UICollectionReusableView() }
                titleHeader.setTitle(title: I18N.Analysis.pointInfo)
                return titleHeader
            } else {
                guard let subHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SubtitleHeaderView.className, for: indexPath) as? SubtitleHeaderView else { return UICollectionReusableView() }
                subHeader.setTitle(title: viewModel.subTitleHeaderList[indexPath.section - 1])
                return subHeader
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isDefaultTap {
            switch section {
            case 0:
                return basicStatList.count
            case 1:
                return viewModel.diagnosisList.count
            default:
                return 0
            }
        } else {
            if section == 0 { return 0 }
            return pointStatList[section-1].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isDefaultTap {
            switch indexPath.section {
            case 0:
                guard let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCVC.className, for: indexPath) as? DefaultCVC else { return UICollectionViewCell() }
                let stat = basicStatList[indexPath.row]
                defaultCell.setData(content: stat.statTitle.title, score: stat.value, unit: stat.statTitle.unit)
                return defaultCell
            case 1:
                guard let diagnosisCell = collectionView.dequeueReusableCell(withReuseIdentifier: DiagnosisCVC.className, for: indexPath) as? DiagnosisCVC else { return UICollectionViewCell() }
                diagnosisCell.setData(icon: viewModel.diagnosisList[indexPath.row].icon,
                                      title: viewModel.diagnosisList[indexPath.row].title,
                                      description: viewModel.diagnosisList[indexPath.row].description)
                return diagnosisCell
            default:
                return UICollectionViewCell()
            }
        } else {
            guard let graphCell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphCVC.className, for: indexPath) as? GraphCVC else { return UICollectionViewCell() }
            graphCell.setData(data: pointStatList[indexPath.section-1][indexPath.row],
                              dataType: "%", type: .analysis)
            return graphCell
        }
    }
}
