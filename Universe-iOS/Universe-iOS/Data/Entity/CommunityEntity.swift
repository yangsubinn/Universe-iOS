//
//  CommunityEntity.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/31.
//

import Foundation

struct CommunityEntity: Codable {
    let matchID, homeWonGameCount, awayWonGameCount: Int
    let thumbnailImageURL: String
    let courtType, stadiumName, matchStartTime: String
    let homeUserIDS, awayUserIDS: [Int]
    let homeUserProfileImageUrls, awayUserProfileImageUrls: [String]
    let homeUserNames, awayUserNames: [String]

    enum CodingKeys: String, CodingKey {
        case matchID = "matchId"
        case homeWonGameCount, awayWonGameCount
        case thumbnailImageURL = "thumbnailImageUrl"
        case courtType, stadiumName, matchStartTime
        case homeUserIDS = "homeUserIds"
        case awayUserIDS = "awayUserIds"
        case homeUserProfileImageUrls, awayUserProfileImageUrls, homeUserNames, awayUserNames
    }
    
    func toDomain() -> CommunityModel {
        return CommunityModel(matchID: self.matchID, homeWonGameCount: self.homeWonGameCount, awayWonGameCount: self.awayWonGameCount, thumbnailImageURL: self.thumbnailImageURL, courtType: self.courtType, stadiumName: self.stadiumName, matchStartTime: self.matchStartTime, homeUserIDS: self.homeUserIDS, awayUserIDS: self.awayUserIDS, homeUserProfileImageUrls: self.homeUserProfileImageUrls, awayUserProfileImageUrls: self.awayUserProfileImageUrls, homeUserNames: self.homeUserNames, awayUserNames: self.awayUserNames)
    }
}

typealias CommunityListEntity = [CommunityEntity]
