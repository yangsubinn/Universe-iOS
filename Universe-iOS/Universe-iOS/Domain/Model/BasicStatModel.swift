//
//  BasicStatModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/17.
//

import Foundation

struct BasicStatModel {
    let stats: [StatModel]
}

struct StatModel {
    let statTitle: BasicStatType
    let value: String
}
