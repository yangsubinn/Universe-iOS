//
//  LoginEntity.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import Foundation

struct LoginEntity: Codable {
    let accessToken: String
    let userId: Int
    
    func toDomain() -> LoginModel {
        return LoginModel(accessToken: self.accessToken, userId: self.userId)
    }
}
