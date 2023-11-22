//
//  MatchScoreEntity.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/02/08.
//

import Foundation

struct MatchScoreEntity: Codable {
    let currentGameCount, homeWonGameCount, awayWonGameCount: Int
    let isLive: Bool
    
    func toDomain() -> MatchScoreModel {
        return MatchScoreModel(currentGameCount: currentGameCount,
                               homeScore: homeWonGameCount,
                               awayScore: awayWonGameCount,
                               isLive: isLive)
    }
}
