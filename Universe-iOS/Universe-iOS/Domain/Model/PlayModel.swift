//
//  PlayModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/02/06.
//

import Foundation

struct GameRequestModel: Codable {
    let matchId: Int
    let gameCount: Int
}

struct MatchRequestModel: Codable {
    let matchId: Int
}

struct PlayModel {
    let randomHomeGameBasicStat, randomAwayGameBasicStat: RandomGameBasicStats
    let randomHomeGameWonPointPercent, randomAwayGameWonPointPercent: RandomGameWonPointPercents
}

struct RandomGameBasicStats {
    let maximumPointGap, maximumContinuousScore, maximumShotSpeed, averageShotSpeed: Double
    let longestRallyTime, averageRallyTime: Int
}

struct RandomGameWonPointPercents {
    let serviceWonPercent, returnWonPercent, forehandWonPercent, backhandWonPercent: Double
    let forehandVolleyWonPercent: Double
    let backhandVolleyWonPercent: Double
    let lobWonPercent, angleWonPercent, spikeWonPercent, courtOutWonPercent: Double
}

struct PlayBasicTimeModel {
    let longestRallyTime: String
    let averageRallyTime: String
}
