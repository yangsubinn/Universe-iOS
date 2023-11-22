//
//  UserAPI.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import Foundation
import Alamofire
import Moya

enum UserAPI {
    case login(email: String, password: String)
    case playerList
    case userProfileInfo
    case basicStat
    case pointStat
    case userAnalysisInfo
}

extension UserAPI: BaseAPI {
    static var apiType: APIType = .user
    
    var path: String {
        switch self {
        case .userProfileInfo:
            return "/info"
        case .basicStat:
            return "/basic-stat"
        case .pointStat:
            return "/point-stat"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        default:
            return .get
        }
    }
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .login(let email, let password):
            params["email"] = email
            params["password"] = password
            params["fcmToken"] = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.fcmToken)
            return params
        default:
            return params
        }
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
    
    var task: Task {
        switch self {
        case .login:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
}
