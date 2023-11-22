//
//  MatchUseCase.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/31.
//

import RxSwift
import RxRelay

protocol MatchUseCase {
    func getIngLiveList()
    func getReplayList()
    func getMyList()
    var ingLiveData: PublishRelay<[CommunityModel]> { get set }
    var replayData: PublishRelay<[CommunityModel]> { get set }
    var myPlayData: PublishRelay<[CommunityModel]> { get set }
}

final class DefaultMatchUseCase {
    
    private let repository: MatchRepository
    private let disposeBag = DisposeBag()
    var ingLiveData = PublishRelay<[CommunityModel]>()
    var replayData = PublishRelay<[CommunityModel]>()
    var myPlayData = PublishRelay<[CommunityModel]>()
    
    init(repository: MatchRepository) {
        self.repository = repository
    }
}

extension DefaultMatchUseCase: MatchUseCase {
    func getIngLiveList() {
        repository.getMatchList(type: .live, list: .all)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.map { $0.toDomain()}
                owner.ingLiveData.accept(model)
            }
            .disposed(by: disposeBag)
    }
    
    func getReplayList() {
        repository.getMatchList(type: .replay, list: .all)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.map { $0.toDomain()}
                owner.replayData.accept(model)
            }
            .disposed(by: disposeBag)
    }
    
    func getMyList() {
        repository.getMatchList(type: .mine, list: .all)
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.map { $0.toDomain() }
                owner.myPlayData.accept(model)
            }
            .disposed(by: disposeBag)
    }
}
