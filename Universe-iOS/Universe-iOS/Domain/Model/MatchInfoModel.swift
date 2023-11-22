//
//  MatchInfoModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/25.
//

import Foundation

struct MatchInfoModel {
    let stadiumName: String
    let homePlayer: [PlayerModel]
    let awayPlayer: [PlayerModel]
    let homeNtrp: String?
    let awayNtrp: String?
    let cameraCount: Int
    
    func toPlayMatchInfoModel() -> PlayMatchInfoModel {
        let homeprofiles = homePlayer.map { $0.profileImage }
        let awayprofiles = awayPlayer.map { $0.profileImage }
        let homenicknames = homePlayer.map { $0.userName }
        let awaynicknames = awayPlayer.map { $0.userName }
        let homeNtrps = homePlayer.map { $0.ntrp }
        let awayNtrps = awayPlayer.map { $0.ntrp }
        return PlayMatchInfoModel(stadiumName: stadiumName,
                                  homeProfiles: homeprofiles,
                                  awayProfiles: awayprofiles,
                                  homeNicknames: homenicknames,
                                  awayNicknames: awaynicknames,
                                  homeNtrps: homeNtrps,
                                  awayNtrps: awayNtrps,
                                  cameraCount: cameraCount)
    }
}

struct PlayMatchInfoModel {
    let stadiumName: String
    let homeProfiles: [String?]
    let awayProfiles: [String?]
    let homeNicknames: [String]
    let awayNicknames: [String]
    let homeNtrps: [String?]
    let awayNtrps: [String?]
    let cameraCount: Int
}
