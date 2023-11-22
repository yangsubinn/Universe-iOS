//
//  BasicStatEntity.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/17.
//

import Foundation

struct BasicStatEntity: Codable {
    let maximumPointGap, maximumContinuousScore, maximumShotSpeed, averageShotSpeed: Double
    let longestRallyTime, averageRallyTime: Int
    
    func toDomain() -> BasicStatModel {
        let longestTime = calculateTime(sec: longestRallyTime)
        let averageTime = calculateTime(sec: averageRallyTime)
        let stats: [StatModel] = [
            StatModel(statTitle: .averageScoreGap, value: String(maximumPointGap)),
            StatModel(statTitle: .averageContinousScore, value: String(maximumContinuousScore)),
            StatModel(statTitle: .maxAttackSpeed, value: String(maximumShotSpeed)),
            StatModel(statTitle: .averageAttackSpeed, value: String(averageShotSpeed)),
            StatModel(statTitle: .maxRallyTime, value: longestTime),
            StatModel(statTitle: .averageRallyTime, value: averageTime)
        ]
        return BasicStatModel(stats: stats)
    }
}
