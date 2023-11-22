//
//  BadgeListEntity.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/19.
//

import Foundation

struct BadgeEntity: Codable {
    let badgeID, userBadgeID: Int
    let name, description: String
    let imageURL: String
    let isIssued, isEquipped: Bool
    
    enum CodingKeys: String, CodingKey {
        case badgeID = "badgeId"
        case userBadgeID = "userBadgeId"
        case name, description
        case imageURL = "imageUrl"
        case isIssued, isEquipped
    }
    
    func toDomain() -> BadgeModel {
        return BadgeModel(id: self.badgeID,
                          name: self.name,
                          description: self.description,
                          imageURL: self.imageURL,
                          isIssued: self.isIssued,
                          isEquipped: self.isEquipped)
    }
}

typealias BadgeListEntity = [BadgeEntity]
