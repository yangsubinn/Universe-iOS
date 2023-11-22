//
//  StadiumUseCase.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/30.
//

import RxSwift
import RxRelay

protocol StadiumUseCase {
    func getStadiumList()
    var ingStadium: PublishRelay<StadiumModel?> { get set }
    var stadiumList: PublishRelay<[StadiumModel]> { get set }
}

final class DefaultStadiumUseCase {
    
    private let repository: StadiumRepository
    private let disposebag = DisposeBag()
    var ingStadium = PublishRelay<StadiumModel?>()
    var stadiumList = PublishRelay<[StadiumModel]>()
    
    init(repository: StadiumRepository) {
        self.repository = repository
    }
}

extension DefaultStadiumUseCase: StadiumUseCase {
    func getStadiumList() {
        repository.getStadiumList()
            .subscribe(onNext: { [weak self] entity in
                guard let self = self else { return }
                guard let entity = entity else { return }
                var model = entity.map { $0.toDomain()}
                self.ingStadium.accept(nil)
                model.enumerated().forEach {
                    if $1.isPlaying {
                        self.ingStadium.accept($1)
                        model.remove(at: $0)
                    }
                }
                self.stadiumList.accept(model)
            }).disposed(by: disposebag)
    }
}
