//
//  MatchService.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

typealias MatchService = BaseService<MatchAPI>

protocol MatchServiceType {
    func postStartMatch(requestModel: MatchStartRequestModel) -> Observable<MatchSuccessEntity?>
    func postStartGame(requestModel: GameRequestModel) -> Observable<PlayEntity?>
    func patchEndGame(requestModel: GameRequestModel) -> Observable<PlayEndEntity?>
    func patchEndMatch(requestModel: MatchRequestModel) -> Observable<Int?>
    func patchStartLive(requestModel: MatchRequestModel) -> Observable<Int?>
    func patchEndLive(requestModel: MatchRequestModel) -> Observable<Int?>
    func getMatchInfo(matchId: Int) -> Observable<MatchInfoEntity?>
    func getMatchScore(matchId: Int) -> Observable<MatchScoreEntity?>
    func getMatchList(type: MatchType, list: MatchListType) -> Observable<CommunityListEntity?>
    func getLatestStat(matchId: Int) -> Observable<PlayEntity?>
}

extension MatchService: MatchServiceType {
    func postStartMatch(requestModel: MatchStartRequestModel) -> Observable<MatchSuccessEntity?> {
        requestObjectInRx(.postStartMatch(request: requestModel))
    }
    
    func postStartGame(requestModel: GameRequestModel) -> Observable<PlayEntity?> {
        requestObjectInRx(.postStartGame(request: requestModel))
    }
    
    func patchEndGame(requestModel: GameRequestModel) -> Observable<PlayEndEntity?> {
        requestObjectInRx(.patchEndGame(request: requestModel))
    }
    
    func patchEndMatch(requestModel: MatchRequestModel) -> Observable<Int?> {
        requestObjectInRxWithNoResult(.patchEndMatch(request: requestModel))
    }
    
    func patchStartLive(requestModel: MatchRequestModel) -> Observable<Int?> {
        requestObjectInRxWithNoResult(.patchStartLive(request: requestModel))
    }
    
    func patchEndLive(requestModel: MatchRequestModel) -> Observable<Int?> {
        requestObjectInRxWithNoResult(.patchEndLive(request: requestModel))
    }
    
    func getMatchInfo(matchId: Int) -> Observable<MatchInfoEntity?> {
        requestObjectInRx(.getMatchInfo(matchId: matchId))
    }
    
    func getMatchScore(matchId: Int) -> Observable<MatchScoreEntity?> {
        requestObjectInRx(.getMatchScore(matchId: matchId))
    }
    
    func getMatchList(type: MatchType, list: MatchListType) -> Observable<CommunityListEntity?> {
        requestObjectInRx(.matchList(type: type, list: list))
    }
    
    func getLatestStat(matchId: Int) -> Observable<PlayEntity?> {
        requestObjectInRx(.getLatestStat(matchId: matchId))
    }
}
