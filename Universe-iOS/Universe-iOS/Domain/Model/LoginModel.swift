//
//  LoginModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/30.
//

import Foundation

struct LoginModel {
    let accessToken: String
    let userId: Int
}

struct LoginRequestModel {
    let email: String
    let password: String
}
