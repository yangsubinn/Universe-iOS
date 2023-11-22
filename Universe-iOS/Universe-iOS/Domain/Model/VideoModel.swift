//
//  VideoModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/17.
//

import Foundation

struct VideoModel {
    let matchId: Int
    let stadiumName: String
    let homeScore: Int
    let awayScore: Int
    let homePlayers: [SimplePlayerModel]
    let awayPlayers: [SimplePlayerModel]
    let ntrp: Double
}

struct SimplePlayerModel {
    let name: String
    let profileImageUrl: String?
}

struct VideoLinkModel {
    let uri: URL
}
