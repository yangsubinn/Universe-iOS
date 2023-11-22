//
//  StadiumRepository.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

protocol StadiumRepository {
    /// 경기장 목록 조회
    func getStadiumList() -> Observable<StadiumListEntity?>
    /// 경기장 상세 조회
    func getStadiumDetail(stadiumId: Int) -> Observable<StadiumDetailEntity?>
}

final class DefaultStadiumRepository {
    
    private let stadiumService: StadiumServiceType
    private let disposeBag = DisposeBag()
    
    init(service: StadiumService) {
        self.stadiumService = service
    }
}

extension DefaultStadiumRepository: StadiumRepository {
    func getStadiumList() -> Observable<StadiumListEntity?> {
        return stadiumService.getStadiumList()
    }
    
    func getStadiumDetail(stadiumId: Int) -> Observable<StadiumDetailEntity?> {
        return stadiumService.getStadiumDetail(stadiumId: stadiumId)
    }
    
}
