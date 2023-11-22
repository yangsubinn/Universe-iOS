//
//  PlanType.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/04.
//

import Foundation

@frozen
enum PlanType: String {
    case basic = "Basic"
    case standard = "Standard"
    case premium = "Premium"
    
    var composition: String {
        switch self {
        case .basic:
            return I18N.Plan.basicComposition
        case .standard:
            return I18N.Plan.standardCompositon
        case .premium:
            return I18N.Plan.premiumComposition
        }
    }
    
    var price: String {
        switch self {
        case .basic:
            return I18N.Plan.basicPrice
        case .standard:
            return I18N.Plan.standardPrice
        case .premium:
            return I18N.Plan.premiumPrice
        }
    }
}
