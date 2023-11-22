//
//  BasicStatType.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/17.
//

import Foundation

@frozen
enum BasicStatType: String {
    case averageScoreGap
    case averageContinousScore
    case maxAttackSpeed
    case averageAttackSpeed
    case maxRallyTime
    case averageRallyTime
    
    var unit: String {
        switch self {
        case .averageScoreGap, .averageContinousScore:
            return "점"
        case .maxAttackSpeed, .averageAttackSpeed:
            return " km/h"
        case .maxRallyTime, .averageRallyTime:
            return ""
        }
    }
    
    var title: String {
        switch self {
        case .averageScoreGap:
            return I18N.Analysis.averageScoreGap
        case .averageContinousScore:
            return I18N.Analysis.averageContinousScore
        case .maxAttackSpeed:
            return I18N.Analysis.maxAttackSpeed
        case .averageAttackSpeed:
            return I18N.Analysis.averageAttackSpeed
        case .maxRallyTime:
            return I18N.Analysis.maxRallyTime
        case .averageRallyTime:
            return I18N.Analysis.averageRallyTime
        }
    }
}
