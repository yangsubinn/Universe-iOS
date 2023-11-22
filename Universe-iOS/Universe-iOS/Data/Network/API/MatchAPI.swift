//
//  MatchAPI.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import Foundation
import Alamofire
import Moya

enum MatchAPI {
    case postStartMatch(request: MatchStartRequestModel)
    case getMatchInfo(matchId: Int)
    case getMatchScore(matchId: Int)
    case getLatestStat(matchId: Int)
    case matchList(type: MatchType, list: MatchListType)
    case postStartGame(request: GameRequestModel)
    case patchEndGame(request: GameRequestModel)
    case patchEndMatch(request: MatchRequestModel)
    case patchStartLive(request: MatchRequestModel)
    case patchEndLive(request: MatchRequestModel)
}

extension MatchAPI: BaseAPI {
    static var apiType: APIType = .match
    
    var path: String {
        switch self {
        case .getMatchInfo(let matchId):
            return "/\(matchId)"
        case .getMatchScore(let matchId):
            return "/score/\(matchId)"
        case .getLatestStat(let matchId):
            return "/stat/\(matchId)"
        case .postStartGame, .patchEndGame:
            return "/game"
        case .patchStartLive:
            return "/new-live"
        case .patchEndLive:
            return "/live"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postStartMatch, .postStartGame:
            return .post
        case .patchEndGame, .patchEndMatch, .patchStartLive, .patchEndLive:
            return .patch
        default:
            return .get
        }
    }
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .postStartMatch(let request):
            params["stadiumId"] = request.stadiumId
            params["courtNumber"] = request.courtNumber
            params["userIds"] = request.playerIdList
        case .postStartGame(let request), .patchEndGame(let request):
            params["matchId"] = request.matchId
            params["gameCount"] = request.gameCount
        case .patchEndMatch(let request):
            params["matchId"] = request.matchId
        case .patchStartLive(let request):
            params["matchId"] = request.matchId
        case .patchEndLive(let request):
            params["matchId"] = request.matchId
        case .matchList(let type, let list):
            params["type"] = type.rawValue
            params["list"] = list.rawValue
        default:
            break
        }
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .postStartMatch, .postStartGame, .patchEndGame, .patchEndMatch, .patchStartLive, .patchEndLive:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        case .matchList:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
}
