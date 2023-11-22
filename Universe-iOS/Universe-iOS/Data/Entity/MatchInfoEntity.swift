//
//  MatchInfoEntity.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/25.
//

import Foundation

struct MatchInfoEntity: Codable {
    let stadiumName: String
    let cameraCount: Int
    let homeUsers, awayUsers: [TeamPlayer]
    let homeAverageNtrp, awayAverageNtrp: Double?
    
    func toDomain() -> MatchInfoModel {
        var homeplayers: [PlayerModel] = [PlayerModel(userId: homeUsers[0].id,
                                                      profileImage: homeUsers[0].profileImageURL,
                                                      userName: homeUsers[0].name,
                                                      ntrp: homeUsers[0].ntrp,
                                                      isSelected: true,
                                                      team: .home,
                                                      isPlaying: true)]
        var awayPlayers: [PlayerModel] = [PlayerModel(userId: awayUsers[0].id,
                                                      profileImage: awayUsers[0].profileImageURL,
                                                      userName: awayUsers[0].name,
                                                      ntrp: awayUsers[0].ntrp,
                                                      isSelected: true,
                                                      team: .away,
                                                      isPlaying: true)]
        if homeUsers.count > 1 && awayUsers.count > 1 {
            let secondHomeUser = homeUsers[1]
            homeplayers.append(PlayerModel(userId: secondHomeUser.id,
                                           profileImage: secondHomeUser.profileImageURL,
                                           userName: secondHomeUser.name,
                                           ntrp: secondHomeUser.ntrp,
                                           isSelected: true,
                                           team: .home,
                                           isPlaying: true))
            
            let secondAwayUser = awayUsers[1]
            awayPlayers.append(PlayerModel(userId: secondAwayUser.id,
                                           profileImage: secondAwayUser.profileImageURL,
                                           userName: secondAwayUser.name,
                                           ntrp: secondAwayUser.ntrp,
                                           isSelected: true,
                                           team: .away,
                                           isPlaying: true))
        }
        return MatchInfoModel(stadiumName: stadiumName,
                              homePlayer: homeplayers,
                              awayPlayer: awayPlayers,
                              homeNtrp: String(homeAverageNtrp ?? 0),
                              awayNtrp: String(awayAverageNtrp ?? 0),
                              cameraCount: cameraCount)
    }
}

struct TeamPlayer: Codable {
    let id: Int
    let name: String
    let profileImageURL: String?
    let ntrp: String?
    let team: String
    let playerNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case profileImageURL = "profileImageUrl"
        case ntrp, team, playerNumber
    }
}
