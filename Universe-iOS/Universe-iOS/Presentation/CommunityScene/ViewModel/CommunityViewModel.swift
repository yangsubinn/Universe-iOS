//
//  CommunityViewModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/08.
//

import RxSwift
import RxRelay

final class CommunityViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: MatchUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    struct Output {
        var ingLiveList = PublishRelay<[CommunityModel]>()
        var replayList = PublishRelay<[CommunityModel]>()
    }
    
    init(useCase: MatchUseCase) {
        self.useCase = useCase
    }
    
}

extension CommunityViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.useCase.getIngLiveList()
            self.useCase.getReplayList()
        })
        .disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let ingLiveDataRelay = useCase.ingLiveData
        let replayDataReplay = useCase.replayData
        
        ingLiveDataRelay.subscribe { model in
            output.ingLiveList.accept(model)
        }.disposed(by: self.disposeBag)
        
        replayDataReplay.subscribe { model in
            output.replayList.accept(model)
        }.disposed(by: self.disposeBag)
    }
}
