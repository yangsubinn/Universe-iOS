//
//  AnalysisUseCase.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/17.
//

import RxSwift
import RxRelay

protocol AnalysisUseCase {
    func getUserInfo()
    func getMyPlayInfo()
    func getBasicStat()
    func getPointStat()
    var userInfo: PublishRelay<AnalysisUserInfoModel> { get set }
    var myPlay: PublishRelay<CommunityModel?> { get set }
    var basicStat: PublishRelay<BasicStatModel> { get set }
    var pointStat: PublishRelay<[[GraphModel]]> { get set }
    var error: PublishRelay<Error> { get set }
}

final class DefaultAnalysisUseCase {
    
    private let userRepository: UserRepository
    private let matchRepository: MatchRepository
    private let disposeBag = DisposeBag()
    var userInfo = PublishRelay<AnalysisUserInfoModel>()
    var myPlay = PublishRelay<CommunityModel?>()
    var basicStat = PublishRelay<BasicStatModel>()
    var pointStat = PublishRelay<[[GraphModel]]>()
    var error = PublishRelay<Error>()
    
    init(userRepository: UserRepository, matchRepository: MatchRepository) {
        self.userRepository = userRepository
        self.matchRepository = matchRepository
    }
}

extension DefaultAnalysisUseCase: AnalysisUseCase {
    func getUserInfo() {
        userRepository.getUserInfo()
            .subscribe(with: self) { (owner, entity) in
                guard let entity = entity else { return }
                let model = entity.toAnalysisDomain()
                owner.userInfo.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getMyPlayInfo() {
        matchRepository.getMatchList(type: .mine, list: .single)
            .subscribe(with: self) { (owner, entity) in
                guard let entity = entity else { return }
                if let entity = entity.first {
                    let model = entity.toDomain()
                    owner.myPlay.accept(model)
                } else {
                    owner.myPlay.accept(nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getBasicStat() {
        userRepository.getBasicStat()
            .subscribe(with: self) { (owner, entity) in
                guard let entity = entity else { return }
                let model = entity.toDomain()
                owner.basicStat.accept(model)
            } onError: { owner, error in
                let model = BasicStatModel(stats: [
                    StatModel(statTitle: .averageScoreGap, value: "0"),
                    StatModel(statTitle: .averageContinousScore, value: "0"),
                    StatModel(statTitle: .maxAttackSpeed, value: "0"),
                    StatModel(statTitle: .averageAttackSpeed, value: "0"),
                    StatModel(statTitle: .maxRallyTime, value: "00:00:00"),
                    StatModel(statTitle: .averageRallyTime, value: "00:00:00")
                ])
                owner.basicStat.accept(model)
                if let error = error as? APIError,
                   error != APIError.decodingErr {
                    owner.error.accept(error)
                }
            }.disposed(by: self.disposeBag)
    }
    
    func getPointStat() {
        userRepository.getPointStat()
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.toAnalysisDomain()
                owner.pointStat.accept(model)
            } onError: { owner, error in
                let model = [
                    [GraphModel(title: I18N.Analysis.serve, leftScore: 0, rightScore: 0),
                     GraphModel(title: I18N.Analysis.returns, leftScore: 0, rightScore: 0)],
                    [GraphModel(title: I18N.Analysis.forehand, leftScore: 0, rightScore: 0),
                     GraphModel(title: I18N.Analysis.backhand, leftScore: 0, rightScore: 0),
                     GraphModel(title: I18N.Analysis.forehandVolley, leftScore: 0, rightScore: 0),
                     GraphModel(title: I18N.Analysis.backhandVolley, leftScore: 0, rightScore: 0),
                     GraphModel(title: I18N.Analysis.lob, leftScore: 0, rightScore: 0),
                     GraphModel(title: I18N.Analysis.angle, leftScore: 0, rightScore: 0),
                     GraphModel(title: I18N.Analysis.spike, leftScore: 0, rightScore: 0)],
                    [GraphModel(title: I18N.Analysis.courtOutLoss, leftScore: 0, rightScore: 0)]]
                owner.pointStat.accept(model)
                if let error = error as? APIError,
                   error != APIError.decodingErr {
                    owner.error.accept(error)
                }
            }.disposed(by: self.disposeBag)
    }
}
