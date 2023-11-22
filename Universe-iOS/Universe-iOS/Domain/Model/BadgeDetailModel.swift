//
//  BadgeDetailModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import Foundation

struct BadgeDetailModel {
    let badgeId: Int
    let isIssued, isEquipped: Bool
    let name, description, imageUrl: String
    let condition: [[String?]]
}
