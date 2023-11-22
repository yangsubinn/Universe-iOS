//
//  DuplicatedUserEntity.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/31.
//

import Foundation

struct DuplicatedUserEntity: Codable {
    let duplicatedUserIDS: [Int]
    
    enum CodingKeys: String, CodingKey {
        case duplicatedUserIDS = "duplicatedUserIds"
    }
}
