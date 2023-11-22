//
//  PlayerListEntity.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/20.
//

import Foundation

struct PlayerEntity: Codable {
    let id: Int
    let name: String
    let profileImageURL: String?
    let ntrp: String?
    let isPlaying: Bool? // 서버 수정 후 ? 삭제

    enum CodingKeys: String, CodingKey {
        case id, name
        case profileImageURL = "profileImageUrl"
        case ntrp, isPlaying
    }
    
    func toPlayerListDomain() -> PlayerModel {
        let myUserId = UserDefaults.standard.integer(forKey: Const.UserDefaultsKey.userId)
        return PlayerModel(userId: id,
                           profileImage: profileImageURL,
                           userName: name,
                           ntrp: ntrp,
                           isSelected: myUserId == id ? true : false,
                           team: myUserId == id ? .home : .none,
                           isPlaying: isPlaying ?? false)
    }
}
