//
//  PlayEntity.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/02/06.
//

import Foundation

struct PlayEntity: Codable {
    let homeGameBasicStat, awayGameBasicStat: RandomGameBasicStat
    let homeGameWonPointPercent, awayGameWonPointPercent: RandomGameWonPointPercent
    
    func toBasicGraphDomain() -> [GraphModel] {
        let home = RandomGameBasicStats(maximumPointGap: self.homeGameBasicStat.maximumPointGap,
                                                    maximumContinuousScore: self.homeGameBasicStat.maximumContinuousScore,
                                                    maximumShotSpeed: self.homeGameBasicStat.maximumShotSpeed,
                                                    averageShotSpeed: self.homeGameBasicStat.averageShotSpeed,
                                                    longestRallyTime: self.homeGameBasicStat.longestRallyTime,
                                                    averageRallyTime: self.homeGameBasicStat.averageRallyTime)
        let away = RandomGameBasicStats(maximumPointGap: self.awayGameBasicStat.maximumPointGap,
                                                    maximumContinuousScore: self.awayGameBasicStat.maximumContinuousScore,
                                                    maximumShotSpeed: self.awayGameBasicStat.maximumShotSpeed,
                                                    averageShotSpeed: self.awayGameBasicStat.averageShotSpeed,
                                                    longestRallyTime: self.awayGameBasicStat.longestRallyTime,
                                                    averageRallyTime: self.awayGameBasicStat.averageRallyTime)
        
        return [GraphModel(title: I18N.Analysis.maxScoreGap,
                           leftScore: Double(home.maximumPointGap), rightScore: Double(away.maximumPointGap)),
        GraphModel(title: I18N.Analysis.maxSeriesScore,
                   leftScore: Double(home.maximumContinuousScore), rightScore: Double(away.maximumContinuousScore)),
        GraphModel(title: I18N.Analysis.maxAttackSpeed,
                   leftScore: Double(home.maximumShotSpeed), rightScore: Double(away.maximumShotSpeed)),
        GraphModel(title: I18N.Analysis.averageAttackSpeed,
                   leftScore: Double(home.averageShotSpeed), rightScore: Double(away.averageShotSpeed))]
    }
    
    func toBasicDomain() -> PlayBasicTimeModel {
        let home = RandomGameBasicStats(maximumPointGap: self.homeGameBasicStat.maximumPointGap,
                                                    maximumContinuousScore: self.homeGameBasicStat.maximumContinuousScore,
                                                    maximumShotSpeed: self.homeGameBasicStat.maximumShotSpeed,
                                                    averageShotSpeed: self.homeGameBasicStat.averageShotSpeed,
                                                    longestRallyTime: self.homeGameBasicStat.longestRallyTime,
                                                    averageRallyTime: self.homeGameBasicStat.averageRallyTime)
        
        return PlayBasicTimeModel(longestRallyTime: calculateTime(sec: home.longestRallyTime),
                                  averageRallyTime: calculateTime(sec: home.averageRallyTime))
    }
    
    func toScoreDomain() -> [[GraphModel]] {
        let home = RandomGameWonPointPercents(serviceWonPercent: self.homeGameWonPointPercent.serviceWonPercent,
                                                                returnWonPercent: self.homeGameWonPointPercent.returnWonPercent,
                                                                forehandWonPercent: self.homeGameWonPointPercent.forehandWonPercent,
                                                                backhandWonPercent: self.homeGameWonPointPercent.backhandWonPercent,
                                                                forehandVolleyWonPercent: self.homeGameWonPointPercent.forehandVolleyWonPercent,
                                                                backhandVolleyWonPercent: self.homeGameWonPointPercent.backhandVolleyWonPercent,
                                                                lobWonPercent: self.homeGameWonPointPercent.lobWonPercent,
                                                                angleWonPercent: self.homeGameWonPointPercent.angleWonPercent,
                                                                spikeWonPercent: self.homeGameWonPointPercent.spikeWonPercent,
                                                                courtOutWonPercent: self.homeGameWonPointPercent.courtOutWonPercent)
        let away = RandomGameWonPointPercents(serviceWonPercent: self.awayGameWonPointPercent.serviceWonPercent,
                                                                returnWonPercent: self.awayGameWonPointPercent.returnWonPercent,
                                                                forehandWonPercent: self.awayGameWonPointPercent.forehandWonPercent,
                                                                backhandWonPercent: self.awayGameWonPointPercent.backhandWonPercent,
                                                                forehandVolleyWonPercent: self.awayGameWonPointPercent.forehandVolleyWonPercent,
                                                                backhandVolleyWonPercent: self.awayGameWonPointPercent.backhandVolleyWonPercent,
                                                                lobWonPercent: self.awayGameWonPointPercent.lobWonPercent,
                                                                angleWonPercent: self.awayGameWonPointPercent.angleWonPercent,
                                                                spikeWonPercent: self.awayGameWonPointPercent.spikeWonPercent,
                                                                courtOutWonPercent: self.awayGameWonPointPercent.courtOutWonPercent)
        
        return [
            [GraphModel(title: I18N.Analysis.serve, leftScore: home.serviceWonPercent, rightScore: away.serviceWonPercent),
             GraphModel(title: I18N.Analysis.returns, leftScore: home.returnWonPercent, rightScore: away.returnWonPercent)],
            [GraphModel(title: I18N.Analysis.forehand, leftScore: home.forehandWonPercent, rightScore: away.forehandWonPercent),
             GraphModel(title: I18N.Analysis.backhand, leftScore: home.backhandWonPercent, rightScore: away.backhandWonPercent),
             GraphModel(title: I18N.Analysis.forehandVolley, leftScore: home.forehandVolleyWonPercent, rightScore: away.forehandVolleyWonPercent),
             GraphModel(title: I18N.Analysis.backhandVolley, leftScore: home.backhandVolleyWonPercent, rightScore: away.backhandVolleyWonPercent),
             GraphModel(title: I18N.Analysis.lob, leftScore: home.lobWonPercent, rightScore: away.lobWonPercent),
             GraphModel(title: I18N.Analysis.angle, leftScore: home.angleWonPercent, rightScore: away.angleWonPercent),
             GraphModel(title: I18N.Analysis.spike, leftScore: home.spikeWonPercent, rightScore: away.spikeWonPercent)],
            [GraphModel(title: I18N.Analysis.courtOutLoss, leftScore: home.courtOutWonPercent, rightScore: away.courtOutWonPercent)]
        ]
    }
}

struct RandomGameBasicStat: Codable {
    let maximumPointGap, maximumContinuousScore, maximumShotSpeed, averageShotSpeed: Double
    let longestRallyTime, averageRallyTime: Int
}

struct RandomGameWonPointPercent: Codable {
    let serviceWonPercent, returnWonPercent, forehandWonPercent, backhandWonPercent: Double
    let forehandVolleyWonPercent: Double
    let backhandVolleyWonPercent: Double
    let lobWonPercent, angleWonPercent, spikeWonPercent, courtOutWonPercent: Double
}

struct PlayEndEntity: Codable {
    let wonTeam: String
    
    func toDomain() -> String {
        return wonTeam
    }
}
