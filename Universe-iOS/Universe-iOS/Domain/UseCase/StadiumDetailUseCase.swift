//
//  StadiumDetailUseCase.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/02/01.
//

import RxSwift
import RxRelay

protocol StadiumDetailUseCase {
    func getStadiumDetail(stadiumId: Int)
    var stadiumData: PublishRelay<StadiumDetailModel> { get set }
    var stadiumThumbnails: PublishRelay<[String]> { get set }
}

final class DefaultStadiumDetailUseCase {
    
    private let repository: StadiumRepository
    private let disposebag = DisposeBag()
    var stadiumData = PublishRelay<StadiumDetailModel>()
    var stadiumThumbnails = PublishRelay<[String]>()
    
    init(repository: StadiumRepository) {
        self.repository = repository
    }
}

extension DefaultStadiumDetailUseCase: StadiumDetailUseCase {
    func getStadiumDetail(stadiumId: Int) {
        repository.getStadiumDetail(stadiumId: stadiumId)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.toDomain()
                owner.stadiumThumbnails.accept(model.stadiumImageUrls)
                owner.stadiumData.accept(model)
            }
            .disposed(by: disposebag)
    }
}
