//
//  PlayerModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import Foundation

@frozen
enum TeamType: CaseIterable {
    case home
    case away
}

struct PlayerModel: Hashable {
    let userId: Int
    let profileImage: String?
    let userName: String
    let ntrp: String?
    let isSelected: Bool
    let team: TeamType?
    let isPlaying: Bool
}
