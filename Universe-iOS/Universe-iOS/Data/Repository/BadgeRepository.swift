//
//  BadgeRepository.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

protocol BadgeRepository {
    func getBadgeList() -> Observable<BadgeListEntity?>
    func getBadgeDetail(badgeId: Int) -> Observable<BadgeDetailEntity?>
}

final class DefaultBadgeRepository {
    
    private let badgeService: BadgeServiceType
    private let disposeBag = DisposeBag()
    
    init(service: BadgeServiceType) {
        self.badgeService = service
    }
}

extension DefaultBadgeRepository: BadgeRepository {
    func getBadgeDetail(badgeId: Int) -> Observable<BadgeDetailEntity?> {
        return badgeService.getBadgeDetail(badgeId: badgeId)
    }
    
    func getBadgeList() -> Observable<BadgeListEntity?> {
        return badgeService.getBadgeList()
    }
}
