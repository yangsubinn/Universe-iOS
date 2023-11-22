//
//  BadgeDetailEntity.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import Foundation

struct BadgeDetailEntity: Codable {
    let badgeID, userBadgeID: Int
    let isIssued, isEquipped: Bool
    let name, description: String
    let imageURL: String
    let condition1, condition1TargetCount: String
    let condition2, condition2TargetCount, condition3, condition3TargetCount: String?

    enum CodingKeys: String, CodingKey {
        case badgeID = "badgeId"
        case userBadgeID = "userBadgeId"
        case isIssued, isEquipped, name, description
        case imageURL = "imageUrl"
        case condition1, condition1TargetCount, condition2, condition2TargetCount, condition3, condition3TargetCount
    }
    
    func toDomain() -> BadgeDetailModel {
        let conditions = [[condition1, condition1TargetCount],
                          [condition2, condition2TargetCount],
                          [condition3, condition3TargetCount]]
        return BadgeDetailModel(badgeId: badgeID,
                                isIssued: isIssued,
                                isEquipped: isEquipped,
                                name: name,
                                description: description,
                                imageUrl: imageURL,
                                condition: conditions)
    }
}
