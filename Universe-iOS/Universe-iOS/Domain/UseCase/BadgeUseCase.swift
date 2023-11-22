//
//  BadgeUseCase.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift
import RxRelay

protocol BadgeUseCase {
    func getBadgeDetail(badgeId: Int)
    func getMyBadgeList()
    var badgeDetailData: PublishRelay<BadgeDetailModel> { get set }
    var myBadgeList: PublishRelay<[BadgeModel]> { get set }
    var error: PublishRelay<Error> { get set }
}

final class DefaultBadgeUseCase {
    
    private let repository: BadgeRepository
    private let disposeBag = DisposeBag()
    var myBadgeList = PublishRelay<[BadgeModel]>()
    var badgeDetailData = PublishRelay<BadgeDetailModel>()
    var error = PublishRelay<Error>()
    
    init(repository: BadgeRepository) {
        self.repository = repository
    }
}

extension DefaultBadgeUseCase: BadgeUseCase {
    func getMyBadgeList() {
        repository.getBadgeList()
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.map { $0.toDomain() }
                owner.myBadgeList.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getBadgeDetail(badgeId: Int) {
        repository.getBadgeDetail(badgeId: badgeId)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.toDomain()
                owner.badgeDetailData.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
}
