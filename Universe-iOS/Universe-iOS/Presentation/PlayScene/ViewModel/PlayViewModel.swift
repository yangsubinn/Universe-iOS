//
//  PlayViewModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/17.
//

import RxSwift
import RxRelay

final class PlayViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: PlayUseCase
    private let disposeBag = DisposeBag()
    let titleHeaderList = [I18N.Analysis.defaultInfo, I18N.Analysis.diagnosis]
    let subTitleHeaderList = [I18N.Analysis.all, I18N.Analysis.movement, I18N.Analysis.etc]
    let defaultGraphList = [I18N.Analysis.maxScoreGap, I18N.Analysis.maxSeriesScore,
                            I18N.Analysis.maxAttackSpeed, I18N.Analysis.averageAttackSpeed]
    let defaultList = [I18N.Analysis.maxRallyTime, I18N.Analysis.averageRallyTime]
    let scoreAnalysisList = [[I18N.Analysis.serve, I18N.Analysis.returns], [I18N.Analysis.forehand, I18N.Analysis.backhand, I18N.Analysis.forehandVolley, I18N.Analysis.backhandVolley, I18N.Analysis.lob, I18N.Analysis.angle, I18N.Analysis.spike], [I18N.Analysis.courtOutLoss]]
    let diagnosisList = [Diagnosis(icon: "W",
                                   title: "로브 방어 취약",
                                   description: "총 N회의 로브 공격에 대하여 N회 이상 실점함"),
                         Diagnosis(icon: "G",
                                   title: "스파이크 득점 우수",
                                   description: "총 N회의 스파이크 공격에 대하여 N회 이상 득점함"),
                         Diagnosis(icon: "G",
                                   title: "앵글 득점 우수",
                                   description: "총 N회의 앵글 공격에 대하여 N회 이상 득점함"),
                         Diagnosis(icon: "W",
                                   title: "코트아웃 실점",
                                   description: "경기 중 N회의 코트아웃으로 실점함")]
    var matchId: Int!
    private var matchInfo: MatchInfoModel?
    private var matchScore: MatchScoreModel?
    var stadiumName: String?
    var startLiveButtonTapped = PublishRelay<Bool>()
    
    // MARK: - Inputs
    
    struct Input {
        let viewDidLoadEvent: Observable<Int>
        let refreshEvent: Observable<Void>
        let gameStartButtonTapEvent: Observable<GameRequestModel>
        let gameEndButtonTapEvent: Observable<GameRequestModel>
        let liveStartButtonTapEvent: Observable<MatchRequestModel>
        let liveEndButtonTapEvent: Observable<MatchRequestModel>
    }
    
    // MARK: - Outputs
    
    struct Output {
        let cameraList = PublishRelay<[CameraModel]>()
        let matchInfo = PublishRelay<PlayMatchInfoModel>()
        let matchScore = PublishRelay<MatchScoreModel>()
        let playBasicGraphInfo = PublishRelay<[GraphModel]>()
        let playBasicInfo = PublishRelay<PlayBasicTimeModel>()
        let playScoreInfo = PublishRelay<[[GraphModel]]>()
        let endGameInfo = PublishRelay<String>()
        let startLiveStatus = PublishRelay<Int>()
        let endLiveStatus = PublishRelay<Int>()
        let videoLink = PublishRelay<VideoLinkModel>()
        let error = PublishRelay<Void>()
    }
    
    // MARK: - Initialize
    
    init(useCase: PlayUseCase, matchId: Int, matchInfo: MatchInfoModel? = nil, matchScore: MatchScoreModel? = nil) {
        self.useCase = useCase
        self.matchId = matchId
        self.matchInfo = matchInfo
        self.matchScore = matchScore
    }
    
    deinit {
        print("🥒 PlayViewModel - deinit")
    }
}

extension PlayViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe { owner, cameraNumber in
                if let matchInfo = owner.matchInfo,
                   let matchScore = owner.matchScore {
                    let info = matchInfo.toPlayMatchInfoModel()
                    output.matchInfo.accept(info)
                    output.matchScore.accept(matchScore)
                    owner.stadiumName = info.stadiumName
                } else {
                    owner.useCase.getMatchInfo(matchId: owner.matchId)
                    owner.useCase.getMatchScore(matchId: owner.matchId)
                }
                
                if owner.matchScore?.currentGameCount ?? 0 > 0 {
                    owner.useCase.getLatestStat(matchId: owner.matchId)
                }
                
                owner.useCase.getVideoLink(matchId: owner.matchId, cameraNumber: cameraNumber)
                owner.useCase.getCameraList(matchId: owner.matchId)
            }
            .disposed(by: self.disposeBag)
        
        input.refreshEvent
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.useCase.getMatchInfo(matchId: owner.matchId)
                owner.useCase.getMatchScore(matchId: owner.matchId)
                
                if owner.matchScore?.currentGameCount ?? 0 > 0 {
                    owner.useCase.getLatestStat(matchId: owner.matchId)
                }
            }.disposed(by: self.disposeBag)
            
        input.gameStartButtonTapEvent
            .withUnretained(self)
            .subscribe { owner, gameInput in
                owner.useCase.postStartGame(request: gameInput)
        }.disposed(by: self.disposeBag)
        
        input.gameEndButtonTapEvent
            .withUnretained(self)
            .subscribe { owner, gameInput in
                owner.useCase.patchEndGame(request: gameInput)
        }.disposed(by: self.disposeBag)
        
        input.liveStartButtonTapEvent
            .withUnretained(self)
            .subscribe { owner, gameInput in
                owner.useCase.patchStartLive(request: gameInput)
        }.disposed(by: self.disposeBag)
        
        input.liveEndButtonTapEvent
            .withUnretained(self)
            .subscribe { owner, gameInput in
                owner.useCase.patchEndLive(request: gameInput)
            }.disposed(by: self.disposeBag)
        
        startLiveButtonTapped
            .withUnretained(self)
            .subscribe { owner, _ in
                let model = MatchRequestModel(matchId: owner.matchId)
                owner.useCase.patchStartLive(request: model)
            }.disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let matchInfoRelay = useCase.matchInfo
        let matchScoreRelay = useCase.matchScore
        let playBasicGraphInfoRelay = useCase.playBasicGraphInfo
        let playBasicInfoRelay = useCase.playBasicInfo
        let playScoreInfoRelay = useCase.playScoreInfo
        let endGameInfoRelay = useCase.endPlayInfo
        let startLiveStatusRelay = useCase.startLiveStatus
        let endLiveStatusRelay = useCase.endLiveStatus
        let videoLinkRelay = useCase.videoLink
        let cameraListRelay = useCase.cameraList
        let errorRelay = useCase.error
        
        matchInfoRelay
            .withUnretained(self)
            .subscribe { owner, model in
                let model = model.toPlayMatchInfoModel()
                owner.stadiumName = model.stadiumName
                output.matchInfo.accept(model)
            }.disposed(by: disposeBag)
        
        matchScoreRelay
            .withUnretained(self)
            .subscribe { owner, model in
                if model.currentGameCount > 0 {
                    owner.useCase.getLatestStat(matchId: owner.matchId)
                }
                output.matchScore.accept(model)
            }.disposed(by: disposeBag)
        
        playBasicGraphInfoRelay.subscribe { model in
            output.playBasicGraphInfo.accept(model)
        }.disposed(by: self.disposeBag)
        
        playBasicInfoRelay.subscribe { model in
            output.playBasicInfo.accept(model)
        }.disposed(by: self.disposeBag)
        
        playScoreInfoRelay.subscribe { model in
            output.playScoreInfo.accept(model)
        }.disposed(by: self.disposeBag)
        
        endGameInfoRelay.subscribe { model in
            output.endGameInfo.accept(model)
        }.disposed(by: self.disposeBag)
        
        startLiveStatusRelay.subscribe { model in
            output.startLiveStatus.accept(model)
        }.disposed(by: self.disposeBag)
        
        endLiveStatusRelay.subscribe { model in
            output.endLiveStatus.accept(model)
        }.disposed(by: self.disposeBag)
        
        videoLinkRelay.subscribe { model in
            output.videoLink.accept(model)
        }.disposed(by: self.disposeBag)
        
        cameraListRelay.subscribe { model in
            output.cameraList.accept(model)
        }.disposed(by: self.disposeBag)
        
        errorRelay.subscribe { error in
            print("PlayViewModel - error:", error)
            output.error.accept(())
        }.disposed(by: disposeBag)
    }
}
