//
//  VideoAPI.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import Foundation
import Alamofire
import Moya

enum VideoAPI {
    case getVideoLink(matchId: Int, cameraNumber: Int)
    case getCameraList(matchId: Int)
}

extension VideoAPI: BaseAPI {
    static var apiType: APIType = .video
    
    var path: String {
        switch self {
        case .getCameraList(let matchId):
            return "/camera/\(matchId)"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .getVideoLink(let matchId, let cameraNumber):
            params["matchId"] = matchId
            params["cameraNumber"] = cameraNumber
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
        case .getVideoLink:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
}
