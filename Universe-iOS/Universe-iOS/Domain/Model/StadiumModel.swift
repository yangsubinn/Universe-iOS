//
//  StadiumModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/15.
//

import Foundation

struct StadiumListModel {
    let stadiums: [StadiumModel]
}

struct StadiumModel {
    let id: Int
    let name: String
    let outdoorCourtCount, indoorCourtCount: Int
    let imageURL: String
    let isPlaying: Bool
    let type: String?
    let courtNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, outdoorCourtCount, indoorCourtCount
        case imageURL = "imageUrl"
        case isPlaying, type, courtNumber
    }
}
