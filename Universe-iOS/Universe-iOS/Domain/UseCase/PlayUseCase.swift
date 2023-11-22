//
//  PlayUseCase.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/02/01.
//

import RxSwift
import RxRelay

protocol PlayUseCase {
    func getMatchInfo(matchId: Int)
    func getMatchScore(matchId: Int)
    func postStartGame(request: GameRequestModel)
    func patchEndGame(request: GameRequestModel)
    func patchEndMatch(request: MatchRequestModel)
    func patchStartLive(request: MatchRequestModel)
    func patchEndLive(request: MatchRequestModel)
    func getVideoLink(matchId: Int, cameraNumber: Int)
    func getLatestStat(matchId: Int)
    func getCameraList(matchId: Int)
    var videoLink: PublishRelay<VideoLinkModel> { get set }
    var cameraList: PublishRelay<[CameraModel]> { get set }
    var matchInfo: PublishRelay<MatchInfoModel> { get set }
    var matchScore: PublishRelay<MatchScoreModel> { get set }
    var playBasicGraphInfo: PublishRelay<[GraphModel]> { get set }
    var playBasicInfo: PublishRelay<PlayBasicTimeModel> { get set }
    var playScoreInfo: PublishRelay<[[GraphModel]]> { get set }
    var endPlayInfo: PublishRelay<String> { get set }
    var endMatchStatus: PublishRelay<Int> { get set }
    var startLiveStatus: PublishRelay<Int> { get set }
    var endLiveStatus: PublishRelay<Int> { get set }
    var error: PublishRelay<Error> { get set }
}

final class DefaultPlayUseCase {
    
    private let matchRepository: MatchRepository
    private let videoRepository: VideoRepository
    private let disposeBag = DisposeBag()
    var videoLink = PublishRelay<VideoLinkModel>()
    var cameraList = PublishRelay<[CameraModel]>()
    var matchInfo = PublishRelay<MatchInfoModel>()
    var matchScore = PublishRelay<MatchScoreModel>()
    var playBasicGraphInfo = PublishRelay<[GraphModel]>()
    var playBasicInfo = PublishRelay<PlayBasicTimeModel>()
    var playScoreInfo = PublishRelay<[[GraphModel]]>()
    var endPlayInfo = PublishRelay<String>()
    var endMatchStatus = PublishRelay<Int>()
    var startLiveStatus = PublishRelay<Int>()
    var endLiveStatus = PublishRelay<Int>()
    var error = PublishRelay<Error>()
    
    init(matchRepository: MatchRepository, videoRepository: VideoRepository) {
        self.matchRepository = matchRepository
        self.videoRepository = videoRepository
    }
}

extension DefaultPlayUseCase: PlayUseCase {
    func getCameraList(matchId: Int) {
        videoRepository.getCameraList(matchId: matchId)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.map { $0.toDomain() }
                owner.cameraList.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getLatestStat(matchId: Int) {
        matchRepository.getLatestStat(matchId: matchId)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let basicGraphModel = entity.toBasicGraphDomain()
                owner.playBasicGraphInfo.accept(basicGraphModel)
                let basicInfoModel = entity.toBasicDomain()
                owner.playBasicInfo.accept(basicInfoModel)
                let playScoreModel = entity.toScoreDomain()
                owner.playScoreInfo.accept(playScoreModel)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getMatchInfo(matchId: Int) {
        matchRepository.getMatchInfo(matchId: matchId)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.toDomain()
                owner.matchInfo.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getMatchScore(matchId: Int) {
        matchRepository.getMatchScore(matchId: matchId)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.toDomain()
                owner.matchScore.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getVideoLink(matchId: Int, cameraNumber: Int) {
        videoRepository.getVideoLink(matchId: matchId, cameraNumber: cameraNumber)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.toDomain()
                owner.videoLink.accept(model)
            }
            .disposed(by: disposeBag)
    }
    
    func postStartGame(request: GameRequestModel) {
        matchRepository.postStartGame(requestModel: request)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let basicGraphModel = entity.toBasicGraphDomain()
                owner.playBasicGraphInfo.accept(basicGraphModel)
                let basicInfoModel = entity.toBasicDomain()
                owner.playBasicInfo.accept(basicInfoModel)
                let playScoreModel = entity.toScoreDomain()
                owner.playScoreInfo.accept(playScoreModel)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func patchEndGame(request: GameRequestModel) {
        matchRepository.patchEndGame(requestModel: request)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.toDomain()
                owner.endPlayInfo.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func patchEndMatch(request: MatchRequestModel) {
        matchRepository.patchEndMatch(requestModel: request)
            .subscribe(with: self) { owner, statusCode in
                guard let statusCode = statusCode else { return }
                owner.endMatchStatus.accept(statusCode)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func patchStartLive(request: MatchRequestModel) {
        matchRepository.patchStartLive(requestModel: request)
            .subscribe(with: self) { owner, statusCode in
                guard let statusCode = statusCode else { return }
                owner.startLiveStatus.accept(statusCode)
            }
            .disposed(by: disposeBag)
    }
    
    func patchEndLive(request: MatchRequestModel) {
        matchRepository.patchEndLive(requestModel: request)
            .subscribe(with: self) { owner, statusCode in
                guard let statusCode = statusCode else { return }
                owner.endLiveStatus.accept(statusCode)
            }
            .disposed(by: disposeBag)
    }
}
