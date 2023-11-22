//
//  PlayerListViewModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/10.
//

import RxSwift
import RxRelay

final class PlayerListViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var playerList: [PlayerModel] = []
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        var playerListRelay = PublishRelay<[PlayerModel]>()
    }
    
    // MARK: - Initialize
    
    init(playerList: [PlayerModel]) {
        self.playerList = playerList
    }
}

extension PlayerListViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe { owner, _ in
                output.playerListRelay.accept(owner.playerList)
            }
        .disposed(by: self.disposeBag)
        
        return output
    }
}
