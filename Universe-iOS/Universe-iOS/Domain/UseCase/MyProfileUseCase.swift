//
//  MyProfileUseCase.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/19.
//

import RxSwift
import RxRelay

protocol MyProfileUseCase {
    func getMyProfileData()
    func getBadgeData()
    var myProfileInfo: PublishRelay<MyProfileModel> { get set }
    var badgeList: PublishRelay<BadgeListModel> { get set }
    var error: PublishRelay<Error> { get set }
}

final class DefaultMyProfileUseCase {
    
    private let userRepository: UserRepository
    private let badgeRepository: BadgeRepository
    private let disposeBag = DisposeBag()
    var myProfileInfo = PublishRelay<MyProfileModel>()
    var badgeList = PublishRelay<BadgeListModel>()
    var error = PublishRelay<Error>()
    
    init(profileRepository: UserRepository, badgeRepository: BadgeRepository) {
        self.userRepository = profileRepository
        self.badgeRepository = badgeRepository
    }
}

extension DefaultMyProfileUseCase: MyProfileUseCase {
    func getMyProfileData() {
        userRepository.getUserProfileInfo()
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.toMyProfileDomain()
                owner.myProfileInfo.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
    func getBadgeData() {
        badgeRepository.getBadgeList()
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.map { $0.toDomain() }
                owner.badgeList.accept(model)
            } onError: { owner, error in
                owner.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
}
