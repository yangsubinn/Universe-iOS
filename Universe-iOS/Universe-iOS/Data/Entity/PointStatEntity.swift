//
//  PointStatEntity.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/17.
//

import Foundation

struct PointStatEntity: Codable {
    let wonPointStat: PointStat
    let lostPointStat: PointStat
    
    func toAnalysisDomain() -> [[GraphModel]] {
        let won = wonPointStat
        let lost = lostPointStat
        return [
            [GraphModel(title: I18N.Analysis.serve, leftScore: won.serviceWonPercent, rightScore: lost.serviceWonPercent),
             GraphModel(title: I18N.Analysis.returns, leftScore: won.returnWonPercent, rightScore: lost.returnWonPercent)],
            [GraphModel(title: I18N.Analysis.forehand, leftScore: won.forehandWonPercent, rightScore: lost.forehandWonPercent),
             GraphModel(title: I18N.Analysis.backhand, leftScore: won.backhandWonPercent, rightScore: lost.backhandWonPercent),
             GraphModel(title: I18N.Analysis.forehandVolley, leftScore: won.forehandVolleyWonPercent, rightScore: lost.forehandVolleyWonPercent),
             GraphModel(title: I18N.Analysis.backhandVolley, leftScore: won.backhandVolleyWonPercent, rightScore: lost.backhandVolleyWonPercent),
             GraphModel(title: I18N.Analysis.lob, leftScore: won.lobWonPercent, rightScore: lost.lobWonPercent),
             GraphModel(title: I18N.Analysis.angle, leftScore: won.angleWonPercent, rightScore: lost.angleWonPercent),
             GraphModel(title: I18N.Analysis.spike, leftScore: won.spikeWonPercent, rightScore: lost.spikeWonPercent)],
            [GraphModel(title: I18N.Analysis.courtOutLoss, leftScore: won.courtOutWonPercent, rightScore: lost.courtOutWonPercent)]
        ]
    }
}

struct PointStat: Codable {
    let serviceWonPercent, returnWonPercent, forehandWonPercent, backhandWonPercent: Double
    let forehandVolleyWonPercent, backhandVolleyWonPercent, lobWonPercent, angleWonPercent: Double
    let spikeWonPercent, courtOutWonPercent: Double
}
