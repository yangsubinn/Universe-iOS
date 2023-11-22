//
//  NetworkError.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/30.
//

import Foundation

enum APIError: Error, Equatable {
    case pathErr // 잘못된 요청
    case serverErr // 서버 에러
    case userInfoErr // 잘못된 요청 (아이디, 비번 틀림)
    case duplicatedUserErr(userId: [Int]) // 유저 중복 실패
    case duplicatedRequest // 중복 요청 (이미 처리된 요청)
    case decodingErr // 디코딩 에러
    case networkErr // 네트워크 에러
    
    var rawname: String {
        switch self {
        case .pathErr:
            return "pathErr"
        case .serverErr:
            return "serverErr"
        case .userInfoErr:
            return "userInfoErr"
        case .duplicatedUserErr:
            return "duplicatedUserErr"
        case .decodingErr:
            return "decodingErr"
        case .networkErr:
            return "networkErr"
        case .duplicatedRequest:
            return "duplicatedRequest"
        }
    }
    
    var value: [Int] {
        switch self {
        case .duplicatedUserErr(let userId):
            return userId
        default:
            return []
        }
    }
    
    var title: String {
        switch self {
        case .pathErr, .serverErr, .decodingErr:
            return I18N.Error.temporaryError
        case .userInfoErr:
            return I18N.Login.checkAccountInfo
        case .duplicatedUserErr:
            return I18N.Play.alreadyPlaying
        case .duplicatedRequest:
            return I18N.Error.duplicatedRequest
        case .networkErr:
            return I18N.Error.networkError
        }
    }
    
    var message: String {
        switch self {
        case .pathErr, .serverErr, .decodingErr:
            return I18N.Error.temporaryErrorDescription
        case .userInfoErr, .duplicatedUserErr:
            return ""
        case .duplicatedRequest:
            return I18N.Error.duplicatedRequestDescription
        case .networkErr:
            return I18N.Error.networkErrorDescription
        }
    }
}
