//
//  StadiumService.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

typealias StadiumService = BaseService<StadiumAPI>

protocol StadiumServiceType {
    func getStadiumList() -> Observable<StadiumListEntity?>
    func getStadiumDetail(stadiumId: Int) -> Observable<StadiumDetailEntity?>
}

extension StadiumService: StadiumServiceType {
    func getStadiumList() -> Observable<StadiumListEntity?> {
        requestObjectInRx(.stadiumList)
    }
    func getStadiumDetail(stadiumId: Int) -> Observable<StadiumDetailEntity?> {
        requestObjectInRx(.stadiumDetail(stadiumId: stadiumId))
    }
}
