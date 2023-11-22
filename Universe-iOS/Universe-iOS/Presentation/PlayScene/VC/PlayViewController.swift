//
//  PlayViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/17.
//

import AVFoundation
import AVKit
import MobileVLCKit
import SnapKit
import Then
import UIKit
import UniverseKit
import RxSwift
import RxRelay
import RxCocoa

class PlayViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: PlayViewModel!
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    private(set) var isDefaultTap = true
    private var player = VLCMediaPlayer()
    private var fullPlayer = VLCMediaPlayer()
    private var liveTestUrl: URL?
    private var media: VLCMedia?
    private lazy var videoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapVideo))
    private lazy var videoDimmedTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapVideoDimmed))
    private lazy var fullVideoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapVideo))
    private lazy var fullVideoDimmedTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapVideoDimmed))
    
    private var isLandscape = UIDevice.current.orientation.isLandscape
    private(set) var gameCount: Int = 0
    
    private(set) var playBasicGraphInfo: [GraphModel] = []
    private(set) var playBasicInfo: PlayBasicTimeModel?
    private(set) var playScoreInfo: [[GraphModel]] = [[]]
    
    private var homeScore = 0
    private var awayScore = 0
    
    var playType: PlayType? = .replay
    var type: PlayViewType? = .disableControl
    
    private weak var timer: Timer?
    private var seconds = 0
    private var playingPoint: Float = 0.0
    
    private var hasEntered = false
    private var isRefreshing = false
    
    // MARK: - UI Components
    
    private var navigationBar = CustomNavigationBar()
    private var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
    }
    private var scrollViewContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleToFill
    }
    private var fullVideoPlayerView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.isHidden = true
        $0.image = Icon.imgLeague.image
    }
    private lazy var minimizeScreenButton = UIButton().then {
        $0.setImage(UIImage(systemName: I18N.Play.minimizeIcon), for: .normal)
        $0.tag = 1
        $0.tintColor = .white
        $0.isHidden = true
        $0.addTarget(self, action: #selector(didTapFullScreen(_:)), for: .touchUpInside)
    }
    private var videoPlayerView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.image = Icon.imgLeague.image
    }
    private var videoDimmedView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.2)
    }
    private var fullVideoDimmedView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.2)
        $0.isHidden = true
    }
    private lazy var playButton = UIButton().then {
        $0.setImage(UIImage(systemName: I18N.Play.playIcon), for: .normal)
        $0.setImage(UIImage(systemName: I18N.Play.pauseIcon), for: .selected)
        $0.backgroundColor = .mainBlue
        $0.layer.cornerRadius = 15
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(touchToPlayVideo(_:)), for: .touchUpInside)
    }
    private lazy var playBackwardButton = UIButton().then {
        $0.setImage(UIImage(systemName: I18N.Play.backwardIcon), for: .normal)
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
    }
    private lazy var playForwardButton = UIButton().then {
        $0.setImage(UIImage(systemName: I18N.Play.forwardIcon), for: .normal)
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
    }
    private var playButtonStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 30
    }
    private lazy var fullPlayButton = UIButton().then {
        $0.setImage(UIImage(systemName: I18N.Play.playIcon), for: .normal)
        $0.setImage(UIImage(systemName: I18N.Play.pauseIcon), for: .selected)
        $0.backgroundColor = .mainBlue
        $0.layer.cornerRadius = 15
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(touchToPlayVideo(_:)), for: .touchUpInside)
    }
    private lazy var fullPlayBackwardButton = UIButton().then {
        $0.setImage(UIImage(systemName: I18N.Play.backwardIcon), for: .normal)
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
    }
    private lazy var fullPlayForwardButton = UIButton().then {
        $0.setImage(UIImage(systemName: I18N.Play.forwardIcon), for: .normal)
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
    }
    private var fullPlayButtonStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 30
    }
    private lazy var fullScreenButton = UIButton().then {
        $0.setImage(UIImage(systemName: I18N.Play.maximizeIcon), for: .normal)
        $0.tag = 0
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(didTapFullScreen(_:)), for: .touchUpInside)
    }
    private var fullVideoSlider = UISlider().then {
        $0.thumbTintColor = .mainBlue
        $0.minimumTrackTintColor = .mainBlue
        $0.maximumTrackTintColor = .gray100
        $0.setThumbImage(UIImage(systemName: I18N.Play.sliderIcon), for: .normal)
        $0.isHidden = true
    }
    private var videoSlider = UISlider().then {
        $0.thumbTintColor = .mainBlue
        $0.minimumTrackTintColor = .mainBlue
        $0.maximumTrackTintColor = .gray100
        $0.setThumbImage(UIImage(systemName: I18N.Play.sliderIcon), for: .normal)
    }
    private let onTimeTitleLabel = UILabel().then {
        $0.text = I18N.Analysis.onTimeAnalysis
        $0.font = .semiBoldFont(ofSize: 18)
        $0.sizeToFit()
    }
    private var changeCameraButton = UIButton().then {
        $0.setTitleColor(.mainBlue, for: .normal)
        $0.titleLabel?.font = .semiBoldFont(ofSize: 14)
        $0.showsMenuAsPrimaryAction = true
        if #available(iOS 15.0, *) {
            $0.changesSelectionAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
    }
    private var gameTitleLabel = UILabel().then {
        $0.text = "-"
        $0.font = .regularFont(ofSize: 12)
        $0.textColor = .gray100
    }
    private var scoreLabel = UILabel().then {
        $0.font = .semiBoldFont(ofSize: 24)
    }
    private var homeProfileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = -10
    }
    private var homeNicknameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 5
    }
    private var homeNtrpStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 9
    }
    private var homeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 5
    }
    private var awayProfileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = -10
    }
    private var awayNicknameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 5
    }
    private var awayNtrpStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 9
    }
    private var awayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 5
    }
    private let dividerLine = UIView().then {
        $0.backgroundColor = .lightGray200
    }
    private var basicInfoButton = UIButton().then {
        $0.setTitle(I18N.Analysis.defaultInfo, for: .normal)
        $0.isSelected = true
    }
    private var scoreInfoButton = UIButton().then {
        $0.setTitle(I18N.Analysis.scoreInfo, for: .normal)
    }
    private lazy var buttons = [basicInfoButton, scoreInfoButton]
    private lazy var buttonStackView = UIStackView(arrangedSubviews: buttons).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    private let indicatorBackgroundView = UIView().then {
        $0.backgroundColor = .grayAlpha
    }
    private let indicatorView = UIView().then {
        $0.backgroundColor = .mainBlue
    }
    private let indicatorWidth = NSLayoutConstraint()
    private let infoCollectionViewFlowLayout = UICollectionViewFlowLayout()
    private(set) lazy var infoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: infoCollectionViewFlowLayout).then {
        $0.isScrollEnabled = false
    }
    private lazy var endPlayButton = CustomButton(title: I18N.Play.endPlay, type: .normal, size: .medium).then {
        $0.addTarget(self, action: #selector(endPlay), for: .touchUpInside)
    }
    private lazy var gameButton = CustomButton(title: "1 게임 시작", type: .abled, size: .medium).then {
        $0.isSelected = false
    }
    
    // MARK: - View Life Cycles
    
    override func loadView() {
        super.loadView()
        bindViewModels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setVideoPlayer()
        setLayout()
        setDelegate()
        setRegister()
        bindActions()
        setTabbar()
        if playType == .live {
            setTimer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        if playType == .live {
            killTimer()
        }
        player.drawable = nil
        fullPlayer.drawable = nil
        player.media = nil
        fullPlayer.media = nil
        media = nil
    }
    
    deinit {
        print("🥒 PlayViewController - deinit")
    }
}

extension PlayViewController {
    
    // MARK: - UI & Layout
    
    private func setTabbar() {
        if let rootVC = self.navigationController?.viewControllers[0],
           rootVC.className == StadiumListViewController.className {
            rootVC.hidesBottomBarWhenPushed = false
        }
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        scoreLabel.text = "\(homeScore) - \(awayScore)"
        navigationBar.setNavibar(self, title: viewModel.stadiumName ?? "-", type: .withBackAndRightButton)
        navigationBar.setRightButton(normal: I18N.Play.startLive, selected: I18N.Play.endLive)
        buttons.forEach {
            $0.setTitleColor(.black, for: .selected)
            $0.setTitleColor(.gray100, for: .normal)
            $0.titleLabel?.font = .mediumFont(ofSize: 14)
        }
        switch type {
        case .disableControl:
            endPlayButton.isHidden = true
            gameButton.isHidden = true
            self.navigationBar.rightButton.isHidden = true
        case .enableControl:
            endPlayButton.isHidden = false
            gameButton.isHidden = false
            self.navigationBar.rightButton.isHidden = false
        case .none:
            return
        }
        videoPlayerView.addGestureRecognizer(videoTapGestureRecognizer)
        videoDimmedView.addGestureRecognizer(videoDimmedTapGestureRecognizer)
        fullVideoPlayerView.addGestureRecognizer(fullVideoTapGestureRecognizer)
        fullVideoDimmedView.addGestureRecognizer(fullVideoDimmedTapGestureRecognizer)
    }
    
    private func setVideoPlayer() {
        player.drawable = self.videoPlayerView
        fullPlayer.drawable = self.fullVideoPlayerView
        playButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        fullPlayButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        playButtonStackView.addArrangedSubviews([playBackwardButton, playButton, playForwardButton])
        fullPlayButtonStackView.addArrangedSubviews([fullPlayBackwardButton, fullPlayButton, fullPlayForwardButton])
        
        switch playType {
        case .live:
            // 라이브 일때
            [videoSlider, playForwardButton, playBackwardButton,
             fullVideoSlider, fullPlayForwardButton, fullPlayBackwardButton].forEach { $0.isHidden = true }
        case .replay:
            // 다시보기 일때
            videoSlider.value = 0.0
            fullVideoSlider.value = 0.0
        case .none:
            return
        }
        self.videoSlider.addTarget(self, action: #selector(changeSliderValue), for: .valueChanged)
        self.fullVideoSlider.addTarget(self, action: #selector(changeSliderValue), for: .valueChanged)
    }
    
    private func setMatchInfo(stadiumName: String, homeProfiles: [String?], awayProfiles: [String?], homeNicknames: [String], awayNicknames: [String], homeNtrps: [String?], awayNtrps: [String?]) {
        navigationBar.setTitle(stadiumName)
        homeProfileStackView.removeAllFromSuperview()
        awayProfileStackView.removeAllFromSuperview()
        homeNicknameStackView.removeAllFromSuperview()
        awayNicknameStackView.removeAllFromSuperview()
        homeNtrpStackView.removeAllFromSuperview()
        awayNtrpStackView.removeAllFromSuperview()
        homeProfiles.forEach {
            let profileImageView = UIImageView()
            if let image = $0 {
                profileImageView.updateServerImage(image)
            }
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.layer.cornerRadius = 31
            profileImageView.clipsToBounds = true
            profileImageView.snp.makeConstraints { make in
                make.width.height.equalTo(62)
            }
            homeProfileStackView.addArrangedSubview(profileImageView)
        }
        awayProfiles.forEach {
            let profileImageView = UIImageView()
            if let image = $0 {
                profileImageView.updateServerImage(image)
            }
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.layer.cornerRadius = 31
            profileImageView.clipsToBounds = true
            profileImageView.snp.makeConstraints { make in
                make.width.height.equalTo(62)
            }
            awayProfileStackView.addArrangedSubview(profileImageView)
        }
        homeNicknames.forEach {
            let nicknameLabel = UILabel()
            nicknameLabel.text = $0
            nicknameLabel.font = .semiBoldFont(ofSize: 16)
            homeNicknameStackView.addArrangedSubview(nicknameLabel)
        }
        awayNicknames.forEach {
            let nicknameLabel = UILabel()
            nicknameLabel.text = $0
            nicknameLabel.font = .semiBoldFont(ofSize: 16)
            awayNicknameStackView.addArrangedSubview(nicknameLabel)
        }
        homeNtrps.forEach {
            let ntrpBackView = UIView()
            let ntrpLabel = UILabel()
            ntrpBackView.backgroundColor = .subBlue
            ntrpLabel.text = "NTRP \($0 ?? "-")"
            ntrpLabel.font = .mediumFont(ofSize: 10)
            ntrpBackView.layer.cornerRadius = 8
            ntrpBackView.addSubview(ntrpLabel)
            ntrpBackView.snp.makeConstraints { make in
                make.height.equalTo(16)
            }
            ntrpLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(5)
            }
            homeNtrpStackView.addArrangedSubview(ntrpBackView)
        }
        awayNtrps.forEach {
            let ntrpBackView = UIView()
            let ntrpLabel = UILabel()
            ntrpBackView.backgroundColor = .subBlue
            ntrpLabel.text = "NTRP \($0 ?? "-")"
            ntrpLabel.font = .mediumFont(ofSize: 10)
            ntrpBackView.layer.cornerRadius = 8
            ntrpBackView.addSubview(ntrpLabel)
            ntrpBackView.snp.makeConstraints { make in
                make.height.equalTo(16)
            }
            ntrpLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(5)
            }
            awayNtrpStackView.addArrangedSubview(ntrpBackView)
        }
        homeStackView.addArrangedSubviews([homeNicknameStackView, homeNtrpStackView])
        awayStackView.addArrangedSubviews([awayNicknameStackView, awayNtrpStackView])
    }
    
    private func setMatchScore(gameCount: Int, homeScore: Int, awayScore: Int, isLive: Bool) {
        self.gameCount = gameCount
        self.scoreLabel.text = "\(homeScore) - \(awayScore)"
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.navigationBar.rightButton.isSelected = isLive
        gameTitleLabel.text = "\(gameCount) GAME"
        if gameCount == homeScore + awayScore {
            // 끝남, 버튼에 다음 세트 시작
            gameButton.isSelected = false
            gameButton.changeState(.abled)
            gameButton.setTitle("\(self.gameCount + 1) 게임 시작", for: .normal)
        } else {
            // 하는 중, 버튼에 이번 세트 종료
            gameButton.isSelected = true
            gameButton.changeState(.ended)
            gameButton.setTitle("\(self.gameCount) 게임 종료", for: .normal)
        }
    }
    
    private func setObservers() {
        self.addObserverAction(.popToStadiumListVC) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func presentStartPlayVC() {
        let startPlayVC = self.moduleFactory.makeStartPlayVC(viewModel: self.viewModel)
        self.present(startPlayVC, animated: true)
    }
    
    private func removeObservers() {
        self.removeObserverAction(.popToStadiumListVC)
    }
    
    private func setLayout() {
        indicatorWidth.constant = (UIScreen.main.bounds.width - 32) / CGFloat(Float(buttons.count))
        
        view.addSubviews([navigationBar, fullVideoPlayerView, fullVideoDimmedView,
                          fullPlayButtonStackView, fullVideoSlider, minimizeScreenButton, scrollView, endPlayButton, gameButton])
        scrollView.addSubview(scrollViewContainerView)
        scrollViewContainerView.addSubviews([videoPlayerView, videoDimmedView, playButtonStackView,
                                             videoSlider, fullScreenButton, onTimeTitleLabel, changeCameraButton,
                                             homeProfileStackView, homeStackView,
                                             awayProfileStackView, awayStackView,
                                             gameTitleLabel, scoreLabel, dividerLine, buttonStackView,
                                             indicatorBackgroundView, indicatorView, infoCollectionView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        fullVideoPlayerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        fullVideoDimmedView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        fullPlayButtonStackView.snp.makeConstraints { make in
            make.center.equalTo(fullVideoDimmedView)
        }
        fullVideoSlider.snp.makeConstraints { make in
            make.centerX.equalTo(fullVideoPlayerView)
            make.leading.equalTo(fullVideoPlayerView).inset(31)
            make.bottom.equalTo(fullVideoPlayerView.snp.bottom).inset(18)
        }
        minimizeScreenButton.snp.makeConstraints { make in
            make.centerY.equalTo(fullVideoSlider.snp.centerY)
            make.leading.equalTo(fullVideoSlider.snp.trailing).offset(5)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        scrollViewContainerView.snp.makeConstraints { make in
            make.centerX.top.leading.equalToSuperview()
            make.bottom.equalTo(self.scrollView.snp.bottom)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view.snp.height).priority(.low)
        }
        videoPlayerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.leading.equalToSuperview()
            make.height.equalTo(228)
        }
        videoDimmedView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.leading.equalToSuperview()
            make.height.equalTo(228)
        }
        playButtonStackView.snp.makeConstraints { make in
            make.center.equalTo(videoPlayerView)
        }
        videoSlider.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(31)
            make.bottom.equalTo(videoPlayerView.snp.bottom).inset(18)
        }
        fullScreenButton.snp.makeConstraints { make in
            make.centerY.equalTo(videoSlider.snp.centerY)
            make.leading.equalTo(videoSlider.snp.trailing).offset(5)
        }
        onTimeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(videoPlayerView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(17)
        }
        changeCameraButton.snp.makeConstraints { make in
            make.centerY.equalTo(onTimeTitleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
        gameTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(onTimeTitleLabel.snp.bottom).offset(35)
        }
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gameTitleLabel.snp.bottom).offset(3)
        }
        homeProfileStackView.snp.makeConstraints { make in
            make.centerY.equalTo(scoreLabel.snp.centerY)
            make.trailing.equalTo(scoreLabel.snp.leading).offset(-27)
            make.height.equalTo(62)
        }
        homeStackView.snp.makeConstraints { make in
            make.centerX.equalTo(homeProfileStackView.snp.centerX)
            make.top.equalTo(homeProfileStackView.snp.bottom).offset(16)
        }
        awayProfileStackView.snp.makeConstraints { make in
            make.centerY.equalTo(scoreLabel.snp.centerY)
            make.leading.equalTo(scoreLabel.snp.trailing).offset(27)
            make.height.equalTo(62)
        }
        awayStackView.snp.makeConstraints { make in
            make.centerX.equalTo(awayProfileStackView.snp.centerX)
            make.top.equalTo(awayProfileStackView.snp.bottom).offset(16)
        }
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(videoPlayerView.snp.bottom).offset(230)
            make.centerX.leading.equalToSuperview()
            make.height.equalTo(8)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(17)
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
        infoCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonStackView.snp.bottom).offset(6)
            make.height.equalTo(self.gameCount == 0 ? 358 : 859)
        }
        endPlayButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        gameButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Methods
    
    private func setDelegate() {
        scrollView.delegate = self
        infoCollectionView.delegate = self
        infoCollectionView.dataSource = self
        player.delegate = self
        fullPlayer.delegate = self
    }
    
    private func setRegister() {
        infoCollectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.className)
        infoCollectionView.register(SubtitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SubtitleHeaderView.className)
        infoCollectionView.register(DefaultCVC.self, forCellWithReuseIdentifier: DefaultCVC.className)
        infoCollectionView.register(DiagnosisCVC.self, forCellWithReuseIdentifier: DiagnosisCVC.className)
        infoCollectionView.register(GraphCVC.self, forCellWithReuseIdentifier: GraphCVC.className)
    }
    
    private func bindViewModels() {
        let input = PlayViewModel.Input(
            viewDidLoadEvent: self.rx.methodInvoked(#selector(UIViewController.viewDidLoad)).map { _ in return 1 }, // 처음에는 항상 1번 카메라로 송출
            refreshEvent: self.rx.methodInvoked(#selector(processTimer))
                .map { [weak self] _ in
                    self?.isRefreshing = true
                    print("🦭리프레시 요청 보냈다")},
            gameStartButtonTapEvent: self.gameButton.rx.tap
                .filter({ [weak self] in
                    self?.gameButton.isSelected == false
                }).map { [weak self] _ in
                    guard let self = self else { return GameRequestModel(matchId: -1, gameCount: -1) }
                    self.hasEntered = true
                    self.isRefreshing = false
                    if self.gameCount == 0 && !self.navigationBar.rightButton.isSelected {
                        self.presentStartPlayVC()
                    }
                    return GameRequestModel(matchId: self.viewModel.matchId, gameCount: self.gameCount + 1)},
            gameEndButtonTapEvent: self.gameButton.rx.tap
                .filter({ [weak self] in
                    self?.gameButton.isSelected == true
                }).map { [weak self] _ in
                    guard let self = self else { return GameRequestModel(matchId: -1, gameCount: -1) }
                    self.hasEntered = false
                    return GameRequestModel(matchId: self.viewModel.matchId, gameCount: self.gameCount)},
            liveStartButtonTapEvent: self.navigationBar.rightButton.rx.tap
                .filter({ [weak self] in
                    self?.navigationBar.rightButton.isSelected == false })
                .map { [weak self] _ in
                    return MatchRequestModel(matchId: (self?.viewModel.matchId)!)},
            liveEndButtonTapEvent: self.navigationBar.rightButton.rx.tap
                .filter({ [weak self] in
                    self?.navigationBar.rightButton.isSelected == true })
                .map { [weak self] _ in
                    return MatchRequestModel(matchId: (self?.viewModel.matchId)!)
                })
        let output = self.viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.matchInfo
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                owner.setMatchInfo(stadiumName: model.stadiumName,
                                   homeProfiles: model.homeProfiles,
                                   awayProfiles: model.awayProfiles,
                                   homeNicknames: model.homeNicknames,
                                   awayNicknames: model.awayNicknames,
                                   homeNtrps: model.homeNtrps,
                                   awayNtrps: model.awayNtrps)
                
            }.disposed(by: disposeBag)
        
        output.matchScore
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                owner.setMatchScore(gameCount: model.currentGameCount, homeScore: model.homeScore,
                                    awayScore: model.awayScore, isLive: model.isLive)
                owner.infoCollectionView.reloadData()
                owner.setCollectionHeightWithBottomInset(collectionView: owner.infoCollectionView, bottomInset: 60)
            }.disposed(by: disposeBag)
        
        output.playBasicGraphInfo
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                // 게임 시작 버튼 누름
                owner.playBasicGraphInfo = model
                owner.infoCollectionView.reloadData()
                owner.setCollectionHeightWithBottomInset(collectionView: owner.infoCollectionView, bottomInset: 60)
                if owner.hasEntered && !owner.isRefreshing {
                    owner.gameButton.isSelected = true
                    owner.gameButton.changeState(CustomButtonType.ended)
                    owner.gameCount += 1
                    owner.gameButton.setTitle("\(owner.gameCount) 게임 종료", for: UIControl.State.normal)
                    owner.gameTitleLabel.text = "\(owner.gameCount) GAME"
                }
            }.disposed(by: disposeBag)
        
        output.playBasicInfo
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                owner.playBasicInfo = model
                owner.infoCollectionView.reloadData()
                owner.setCollectionHeightWithBottomInset(collectionView: owner.infoCollectionView, bottomInset: 60)
            }.disposed(by: disposeBag)
        
        output.playScoreInfo
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                owner.playScoreInfo = model
                owner.infoCollectionView.reloadData()
                owner.setCollectionHeightWithBottomInset(collectionView: owner.infoCollectionView, bottomInset: 60)
            }.disposed(by: disposeBag)
        
        output.endGameInfo
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                // 게임 종료 버튼 누름
                owner.gameButton.isSelected = false
                owner.gameButton.changeState(CustomButtonType.abled)
                owner.gameButton.setTitle("\(owner.gameCount + 1) 게임 시작", for: UIControl.State.normal)
                
                if model == "home" {
                    owner.homeScore += 1
                } else {
                    owner.awayScore += 1
                }
                owner.scoreLabel.text = "\(owner.homeScore) - \(owner.awayScore)"
            }.disposed(by: disposeBag)
        
        output.startLiveStatus
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                if model == 200 {
                    owner.navigationBar.rightButton.isSelected.toggle()
                }
            }.disposed(by: disposeBag)
        
        output.endLiveStatus
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                if model == 200 {
                    owner.navigationBar.rightButton.isSelected.toggle()
                }
            }.disposed(by: disposeBag)
        
        output.videoLink
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                // 비디오 링크 넣어주기
                owner.liveTestUrl = model.uri
                owner.media = VLCMedia(url: owner.liveTestUrl!)
                owner.player.media = owner.media
                owner.fullPlayer.media = owner.media
                if owner.playType == .live {
                    owner.player.play()
                    owner.fullPlayer.play()
                    owner.playButton.isSelected.toggle()
                    owner.fullPlayButton.isSelected.toggle()
                }
            }.disposed(by: disposeBag)
        
        output.cameraList
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, model in
                let cameraCount = model.count
                
                var cameraMenus: [UIAction] = []
                
                for cameraNum in 1...cameraCount {
                    let cameraAction = UIAction(title: "\(I18N.Play.changeCamera) (\(cameraNum))",
                                                image: UIImage(systemName: "camera"),
                                                handler: { _ in
                        // 카메라 변경, 영상 변경
                        guard let liveTestUrl = model[cameraNum-1].tennisVideoUrl else { return }
                        owner.media = VLCMedia(url: liveTestUrl)
                        owner.player.media = owner.media
                        owner.fullPlayer.media = owner.media
                        
                        owner.player.position = owner.playingPoint
                        owner.fullPlayer.position = owner.playingPoint
                        
                        owner.videoSlider.value = owner.playingPoint
                        owner.fullVideoSlider.value = owner.playingPoint
                        
                        owner.player.play()
                        owner.fullPlayer.play()
                        owner.playButton.isSelected = true
                        owner.fullPlayButton.isSelected = true
                    })
                    cameraMenus.append(cameraAction)
                }
                owner.changeCameraButton.menu = UIMenu(title: I18N.Play.camera,
                                                      identifier: nil,
                                                      options: .displayInline,
                                                      children: cameraMenus)
            }.disposed(by: disposeBag)
        
        output.error
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.showNetworkAlert { _ in
                    owner.navigationController?.popViewController(animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindActions() {
        basicInfoButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.tappedBasicInfoButton()
                owner.makeVibrate(degree: .medium)
            }.disposed(by: self.disposeBag)
        
        scoreInfoButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.tappedScoreInfoButton()
                owner.makeVibrate(degree: .medium)
            }.disposed(by: self.disposeBag)
        
        gameButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.makeVibrate(degree: .medium)
            }.disposed(by: self.disposeBag)
        
        endPlayButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.makeVibrate(degree: .medium)
            }.disposed(by: self.disposeBag)
    }
    
    private func tappedBasicInfoButton() {
        if !basicInfoButton.isSelected {
            basicInfoButton.isSelected.toggle()
            scoreInfoButton.isSelected.toggle()
            isDefaultTap.toggle()
            moveIndicatorBarWithAnimation()
            scrollView.setContentOffset(CGPoint(x: 0, y: infoCollectionView.numberOfSections == 1 ? 200 : 420), animated: true)
            infoCollectionView.reloadData()
            setCollectionHeightWithBottomInset(collectionView: infoCollectionView, bottomInset: 60)
        }
    }
    
    private func tappedScoreInfoButton() {
        if !scoreInfoButton.isSelected {
            scoreInfoButton.isSelected.toggle()
            basicInfoButton.isSelected.toggle()
            isDefaultTap.toggle()
            moveIndicatorBarWithAnimation(constant: Float((UIScreen.main.bounds.width - 32)) / 2)
            scrollView.setContentOffset(CGPoint(x: 0, y: infoCollectionView.numberOfSections == 1 ? 200 : 420), animated: true)
            infoCollectionView.reloadData()
            setCollectionHeightWithBottomInset(collectionView: infoCollectionView, bottomInset: 60)
        }
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
    
    private func setTimer() {
        // 타이머 간격을 5초에 한번씩으로 설정
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
    }
    
    private func killTimer() {
        timer?.invalidate()
    }
    
    // MARK: - @objc
    
    @objc
    func processTimer() {
        seconds += 5
    }
    
    @objc
    private func endPlay() {
        let endPlayVC = moduleFactory.makeEndPlayVC(isDone: !gameButton.isSelected, matchId: self.viewModel.matchId)
        self.present(endPlayVC, animated: true)
    }
    
    @objc
    private func touchToPlayVideo(_ sender: UIButton) {
        if sender.isSelected {
            player.pause()
            fullPlayer.pause()
            if playType == .replay {
                UIView.animate(withDuration: 2.0, delay: 2.0, options: .transitionCrossDissolve, animations: {
                    self.videoSlider.isHidden = true
                    self.fullVideoSlider.isHidden = true
                })
            }
        } else {
            player.play()
            fullPlayer.play()
        }
        playButton.isSelected.toggle()
        fullPlayButton.isSelected.toggle()
    }
    
    @objc
    private func didTapVideo() {
        let smallPlayer = [videoDimmedView, playButtonStackView, fullScreenButton]
        let fullPlayer = [fullVideoDimmedView, fullPlayButtonStackView, minimizeScreenButton]
        
        UIView.animate(withDuration: 2.0, delay: 2.0, options: .transitionCrossDissolve, animations: {
            smallPlayer.forEach { $0.isHidden = false }
            if self.isLandscape {
                fullPlayer.forEach { $0.isHidden = false }
            }
        })
        
        if playType == .replay {
            UIView.animate(withDuration: 2.0, delay: 2.0, options: .transitionCrossDissolve, animations: {
                self.videoSlider.isHidden = false
                if self.isLandscape {
                    self.fullVideoSlider.isHidden = false
                }
            })
        }
    }
    
    @objc
    private func didTapVideoDimmed() {
        UIView.transition(with: playButtonStackView, duration: 0.4, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.videoDimmedView.isHidden = true
            self?.playButtonStackView.isHidden = true
            self?.fullScreenButton.isHidden = true
        })
        UIView.transition(with: fullPlayButtonStackView, duration: 0.4, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.fullVideoDimmedView.isHidden = true
            self?.fullPlayButtonStackView.isHidden = true
            self?.minimizeScreenButton.isHidden = true
        })
        
        if playType == .replay {
            UIView.animate(withDuration: 2.0, delay: 2.0, options: .transitionCrossDissolve, animations: {
                self.videoSlider.isHidden = true
                self.fullVideoSlider.isHidden = true
            })
        }
    }
    
    @objc
    private func changeSliderValue(_ sender: UISlider) {
        playingPoint = sender.value
        player.position = playingPoint
        fullPlayer.position = playingPoint
        videoSlider.value = playingPoint
        fullVideoSlider.value = playingPoint
        if sender.value == 1.0 {
            playButton.isSelected = false
            fullPlayButton.isSelected = false
        }
    }
    
    @objc
    private func didTapForward() {
        player.position = 1.0
        fullPlayer.position = 1.0
        videoSlider.value = 1.0
        playButton.isSelected = false
        fullVideoSlider.value = 1.0
        fullPlayButton.isSelected = false
    }
    
    @objc
    private func didTapBackward() {
        player.position = 0.0
        fullPlayer.position = 0.0
        videoSlider.value = 0.0
        fullVideoSlider.value = 0.0
        player.play()
        fullPlayer.play()
    }
    
    @objc
    private func didTapFullScreen(_ sender: UIButton) {
        let toHide = [navigationBar, scrollView, endPlayButton, gameButton]
        let fullPlayer = [fullVideoPlayerView, fullVideoDimmedView,
                          fullPlayButtonStackView, minimizeScreenButton]
        
        if sender.tag == 0 {
            self.setDeviceOrientation(orientation: .landscapeRight)
            OrientationManager.lockOrientation(.landscapeRight, rotateTo: .landscapeRight)
            isLandscape = true
            view.backgroundColor = .black
            toHide.forEach { $0.isHidden = true }
            fullPlayer.forEach { $0.isHidden = false }
            if playType == .replay { fullVideoSlider.isHidden = false }
        } else {
            self.setDeviceOrientation(orientation: .portrait)
            OrientationManager.lockOrientation(.portrait, rotateTo: .portrait)
            isLandscape = false
            view.backgroundColor = .white
            toHide.forEach { $0.isHidden = false }
            fullPlayer.forEach { $0.isHidden = true }
            if playType == .replay { fullVideoSlider.isHidden = true }
        }
        if type == .disableControl {
            endPlayButton.isHidden = true
            gameButton.isHidden = true
        }
        sender.isSelected.toggle()
    }
}

// MARK: - VLCMediaPlayerDelegate

extension PlayViewController: VLCMediaPlayerDelegate {
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        videoPlayerView.activityStopAnimating()
        videoSlider.value = player.position
        fullVideoSlider.value = fullPlayer.position
        if player.position == 1.0 && fullPlayer.position == 1.0 {
            playButton.isSelected = false
        }
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if player.state == .buffering && fullPlayer.state == .buffering {
            videoPlayerView.activityStartAnimating(activityColor: .white,
                                                   backgroundColor: .clear)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension PlayViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
}
