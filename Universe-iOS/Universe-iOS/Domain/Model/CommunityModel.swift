//
//  CommunityModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/31.
//

import Foundation

struct CommunityModel {
    let matchID, homeWonGameCount, awayWonGameCount: Int
    let thumbnailImageURL: String
    let courtType, stadiumName, matchStartTime: String
    let homeUserIDS, awayUserIDS: [Int]
    let homeUserProfileImageUrls, awayUserProfileImageUrls: [String]
    let homeUserNames, awayUserNames: [String]
}
