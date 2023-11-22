//
//  BadgeModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/04.
//

import Foundation

struct BadgeModel {
    let id: Int
    let name: String
    let description: String
    let imageURL: String
    let isIssued: Bool
    let isEquipped: Bool
}

typealias BadgeListModel = [BadgeModel]
