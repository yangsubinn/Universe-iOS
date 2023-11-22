//
//  UserInfoEntity.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/17.
//

import Foundation

struct UserInfoEntity: Codable {
    let id: Int
    let name: String
    let profileImageURL: String?
    let ntrp: String?
    let mannerPoint: String?
    let age: Int?
    let gender: String?
    let playedYear: Int?
    let isPro: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case profileImageURL = "profileImageUrl"
        case gender, age, playedYear, ntrp, mannerPoint, isPro
    }
    
    func toAnalysisDomain() -> AnalysisUserInfoModel {
        return AnalysisUserInfoModel(id: self.id,
                                     userName: self.name,
                                     profileImageUrl: self.profileImageURL,
                                     ntrp: self.ntrp,
                                     manner: self.mannerPoint,
                                     age: self.age,
                                     gender: self.gender,
                                     playedYear: self.playedYear)
    }
    
    func toMyProfileDomain() -> MyProfileModel {
        return MyProfileModel(profileImageURL: self.profileImageURL,
                              userName: self.name,
                              nrtp: self.ntrp,
                              manner: self.mannerPoint,
                              plan: .basic,
                              isPro: self.isPro)
    }
}

struct VideoEntity: Codable {
    let id: Int
    let stadiumName: String
    let homeWonGameCount: Int
    let awayWonGameCount: Int
    let thumbnailImageUrl: String?
    let homeFirstUserName: String
    let homeFirstUserProfileImageUrl: String?
    let homeSecondUserName: String?
    let homeSecondUserProfileImageUrl: String?
    let awayFirstUserName: String
    let awayFirstProfileImageUrl: String?
    let awaySecondUserName: String?
    let awaySecondProfileImageUrl: String?
    let averageNtrp: Double
    
    func toDomain() -> VideoModel {
        var homePlayers = [SimplePlayerModel.init(name: homeFirstUserName,
                                                  profileImageUrl: homeFirstUserProfileImageUrl)]
        if let homeSecondUserName = homeSecondUserName {
            homePlayers.append(SimplePlayerModel.init(name: homeSecondUserName, profileImageUrl: homeSecondUserProfileImageUrl))
        }
        
        var awayPlayers = [SimplePlayerModel(name: awayFirstUserName,
                                            profileImageUrl: awayFirstProfileImageUrl)]
        if let awaySecondUserName = awaySecondUserName {
            awayPlayers.append(SimplePlayerModel(name: awaySecondUserName, profileImageUrl: awaySecondProfileImageUrl))
        }
        
        return VideoModel(matchId: id,
                          stadiumName: stadiumName,
                          homeScore: homeWonGameCount,
                          awayScore: awayWonGameCount,
                          homePlayers: homePlayers,
                          awayPlayers: awayPlayers,
                          ntrp: averageNtrp)
    }
}
