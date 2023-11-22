//
//  AddPlayerUseCase.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/20.
//

import RxSwift
import RxRelay

protocol AddPlayerUseCase {
    func getPlayerList()
    func getMatchInfo(matchId: Int)
    func getMatchScore(matchId: Int)
    func postStartMatch(requestModel: MatchStartRequestModel)
    var myInfo: PublishRelay<PlayerModel> { get set }
    var playerList: PublishRelay<[PlayerModel]> { get set }
    var matchInfo: PublishRelay<MatchInfoModel> { get set }
    var matchId: PublishRelay<Int> { get set }
    var matchScoreInfo: PublishRelay<MatchScoreModel> { get set }
    var duplicatedUserId: PublishRelay<[Int]> { get set }
    var error: PublishRelay<Error> { get set }
}

final class DefaultAddPlayerUseCase {
    
    private let matchRepository: MatchRepository
    private let userRepository: UserRepository
    private let disposeBag = DisposeBag()
    var myInfo = PublishRelay<PlayerModel>()
    var playerList = PublishRelay<[PlayerModel]>()
    var matchInfo = PublishRelay<MatchInfoModel>()
    var matchId = PublishRelay<Int>()
    var matchScoreInfo = PublishRelay<MatchScoreModel>()
    var duplicatedUserId = PublishRelay<[Int]>()
    var error = PublishRelay<Error>()
    
    init(matchRepository: MatchRepository, userRepository: UserRepository) {
        self.matchRepository = matchRepository
        self.userRepository = userRepository
    }
}

extension DefaultAddPlayerUseCase: AddPlayerUseCase {
    func getPlayerList() {
        userRepository.getPlayerList()
            .subscribe(with: self) { (owner, entity) in
                guard let entity = entity else { return }
                var model = entity.map { $0.toPlayerListDomain() }
                for i in model.indices where model[i].isSelected {
                    owner.myInfo.accept(model[i])
                    model.remove(at: i)
                    break
                }
                owner.playerList.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getMatchInfo(matchId: Int) {
        matchRepository.getMatchInfo(matchId: matchId)
            .subscribe(with: self) { (owner, entity) in
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
            .subscribe(with: self) { (owner, entity) in
                guard let entity = entity else { return }
                let model = entity.toDomain()
                owner.matchScoreInfo.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func postStartMatch(requestModel: MatchStartRequestModel) {
        matchRepository.postStartMatch(requestModel: requestModel)
            .subscribe(with: self) { (owner, entity) in
                guard let entity = entity else { return }
                owner.matchId.accept(entity.id)
            } onError: { owner, error in
                guard let error = error as? APIError else { return }
                if error.rawname == "duplicatedUserErr" {
                    owner.duplicatedUserId.accept(error.value)
                } else {
                    owner.error.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
