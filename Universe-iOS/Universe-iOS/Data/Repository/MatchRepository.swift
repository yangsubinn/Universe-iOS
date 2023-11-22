//
//  MatchRepository.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

protocol MatchRepository {
    func getMatchInfo(matchId: Int) -> Observable<MatchInfoEntity?>
    func getMatchScore(matchId: Int) -> Observable<MatchScoreEntity?>
    func getLatestStat(matchId: Int) -> Observable<PlayEntity?>
    func postStartMatch(requestModel: MatchStartRequestModel) -> Observable<MatchSuccessEntity?>
    func postStartGame(requestModel: GameRequestModel) -> Observable<PlayEntity?>
    func patchEndGame(requestModel: GameRequestModel) -> Observable<PlayEndEntity?>
    func patchEndMatch(requestModel: MatchRequestModel) -> Observable<Int?>
    func patchStartLive(requestModel: MatchRequestModel) -> Observable<Int?>
    func patchEndLive(requestModel: MatchRequestModel) -> Observable<Int?>
    func getMatchList(type: MatchType, list: MatchListType) -> Observable<CommunityListEntity?>
}

final class DefaultMatchRepository {
    
    private let matchService: MatchServiceType
    private let disposeBag = DisposeBag()
    
    init(service: MatchServiceType) {
        self.matchService = service
    }
}

extension DefaultMatchRepository: MatchRepository {
    func getMatchInfo(matchId: Int) -> Observable<MatchInfoEntity?> {
        return matchService.getMatchInfo(matchId: matchId)
    }
    
    func getMatchScore(matchId: Int) -> Observable<MatchScoreEntity?> {
        return matchService.getMatchScore(matchId: matchId)
    }
    
    func getMatchList(type: MatchType, list: MatchListType) -> Observable<CommunityListEntity?> {
        return matchService.getMatchList(type: type, list: list)
    }

    func getLatestStat(matchId: Int) -> Observable<PlayEntity?> {
        return matchService.getLatestStat(matchId: matchId)
    }
    
    func postStartMatch(requestModel: MatchStartRequestModel) -> Observable<MatchSuccessEntity?> {
        return matchService.postStartMatch(requestModel: requestModel)
    }
    
    func postStartGame(requestModel: GameRequestModel) -> Observable<PlayEntity?> {
        return matchService.postStartGame(requestModel: requestModel)
    }
    
    func patchEndGame(requestModel: GameRequestModel) -> Observable<PlayEndEntity?> {
        return matchService.patchEndGame(requestModel: requestModel)
    }
    
    func patchEndMatch(requestModel: MatchRequestModel) -> Observable<Int?> {
        return matchService.patchEndMatch(requestModel: requestModel)
    }
    
    func patchStartLive(requestModel: MatchRequestModel) -> Observable<Int?> {
        return matchService.patchStartLive(requestModel: requestModel)
    }
    
    func patchEndLive(requestModel: MatchRequestModel) -> Observable<Int?> {
        return matchService.patchEndLive(requestModel: requestModel)
    }
}
