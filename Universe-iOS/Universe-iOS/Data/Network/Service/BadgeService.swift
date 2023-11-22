//
//  BadgeService.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

typealias BadgeService = BaseService<BadgeAPI>

protocol BadgeServiceType {
    func getBadgeList() -> Observable<BadgeListEntity?>
    func getBadgeDetail(badgeId: Int) -> Observable<BadgeDetailEntity?>
}

extension BadgeService: BadgeServiceType {
    func getBadgeList() -> Observable<BadgeListEntity?> {
        requestObjectInRx(.badgeList)
    }
    
    func getBadgeDetail(badgeId: Int) -> Observable<BadgeDetailEntity?> {
        requestObjectInRx(.badgeDetail(badgeId: badgeId))
    }
}
