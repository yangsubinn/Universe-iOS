//
//  UserService.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

typealias UserService = BaseService<UserAPI>

protocol UserServiceType {
    func login(email: String, password: String) -> Observable<LoginEntity?>
    func getUserInfo() -> Observable<UserInfoEntity?>
    func getBasicStat() -> Observable<BasicStatEntity?>
    func getPointStat() -> Observable<PointStatEntity?>
    func getUserList() -> Observable<[PlayerEntity]?>
}

extension UserService: UserServiceType {
    func login(email: String, password: String) -> Observable<LoginEntity?> {
        requestObjectInRx(.login(email: email, password: password))
    }
    
    func getUserInfo() -> Observable<UserInfoEntity?> {
        requestObjectInRx(.userProfileInfo)
    }
    
    func getBasicStat() -> Observable<BasicStatEntity?> {
        requestObjectInRx(.basicStat)
    }
    
    func getPointStat() -> Observable<PointStatEntity?> {
        requestObjectInRx(.pointStat)
    }
    
    func getUserList() -> Observable<[PlayerEntity]?> {
        requestObjectInRx(.playerList)
    }
}
