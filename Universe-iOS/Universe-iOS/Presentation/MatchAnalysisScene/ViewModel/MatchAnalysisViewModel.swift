//
//  MatchAnalysisViewModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/02/03.
//

import RxSwift
import RxRelay

final class MatchAnalysisViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: MatchUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var myPlayList = PublishRelay<[CommunityModel]>()
    }
    
    // MARK: - Initialize
    
    init(useCase: MatchUseCase) {
        self.useCase = useCase
    }
}

extension MatchAnalysisViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.useCase.getMyList()
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let myPlayDataRelay = useCase.myPlayData
        
        myPlayDataRelay.subscribe { model in
            output.myPlayList.accept(model)
        }.disposed(by: self.disposeBag)
    }
}
