//
//  UserRepository.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

protocol UserRepository {
    /// 로그인
    func postUserLogin(email: String, password: String) -> Observable<LoginEntity?>
    /// 유저 정보 조회
    func getUserProfileInfo() -> Observable<UserInfoEntity?>
    /// 유저 목록 조회
    func getPlayerList() -> Observable<[PlayerEntity]?>
    /// 유저 정보 + 최근 경기 조회
    func getUserInfo() -> Observable<UserInfoEntity?>
    /// 기본 정보 조회
    func getBasicStat() -> Observable<BasicStatEntity?>
    /// 득실점 정보 조회
    func getPointStat() -> Observable<PointStatEntity?>
}

final class DefaultUserRepository {
    
    private let userService: UserServiceType
    private let disposeBag = DisposeBag()
    
    init(service: UserServiceType) {
        self.userService = service
    }
}

extension DefaultUserRepository: UserRepository {
    func postUserLogin(email: String, password: String) -> Observable<LoginEntity?> {
        return userService.login(email: email, password: password)
    }
    
    func getUserProfileInfo() -> Observable<UserInfoEntity?> {
        return userService.getUserInfo()
    }
    
    func getPlayerList() -> Observable<[PlayerEntity]?> {
        return userService.getUserList()
    }
    
    func getUserInfo() -> Observable<UserInfoEntity?> {
        return userService.getUserInfo()
    }
    
    func getBasicStat() -> Observable<BasicStatEntity?> {
        return userService.getBasicStat()
    }
    
    func getPointStat() -> Observable<PointStatEntity?> {
        return userService.getPointStat()
    }
}
