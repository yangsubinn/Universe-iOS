//
//  StadiumAPI.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import Foundation
import Alamofire
import Moya

enum StadiumAPI {
    case stadiumList
    case stadiumDetail(stadiumId: Int)
}

extension StadiumAPI: BaseAPI {
    static var apiType: APIType = .stadium
    
    var path: String {
        switch self {
        case .stadiumDetail(let stadiumId):
            return "/\(stadiumId)"
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
        let params: Parameters = [:]
        switch self {
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
    
    var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }
}
