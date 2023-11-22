//
//  StadiumEntity.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/30.
//

import Foundation

struct StadiumEntity: Codable {
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
    
    func toDomain() -> StadiumModel {
        return StadiumModel(id: self.id, name: self.name, outdoorCourtCount: self.outdoorCourtCount, indoorCourtCount: self.indoorCourtCount, imageURL: self.imageURL, isPlaying: self.isPlaying, type: self.type, courtNumber: self.courtNumber)
    }
}

typealias StadiumListEntity = [StadiumEntity]
