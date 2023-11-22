//
//  BaseAPI.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import Moya

enum APIType {
    case user
    case badge
    case stadium
    case match
    case video
}

protocol BaseAPI: TargetType {
    static var apiType: APIType { get set }
}

extension BaseAPI {
    public var baseURL: URL {
        var baseUrl = Config.Network.baseURL
        
        switch Self.apiType {
        case .user:
            baseUrl += "/user"
        case .badge:
            baseUrl += "/badge"
        case .stadium:
            baseUrl += "/stadium"
        case .match:
            baseUrl += "/match"
        case .video:
            baseUrl += "/video"
        }
        
        guard let url = URL(string: baseUrl) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    public var headers: [String: String]? {
        var header: [String: String] = ["Content-Type": "application/json"]
        
        if let token = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) {
            header.updateValue(token, forKey: "authorization")
        }
        
        return header
    }
}
