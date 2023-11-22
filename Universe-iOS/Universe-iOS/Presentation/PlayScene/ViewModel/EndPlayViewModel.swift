//
//  EndPlayViewModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/02/07.
//

import RxSwift
import RxRelay

final class EndPlayViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: PlayUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let matchEndButtonTapEvent: Observable<MatchRequestModel>
    }
    
    // MARK: - Outputs
    
    struct Output {
        let endMatchStatus = PublishRelay<Int>()
        let error = PublishRelay<Void>()
    }
    
    // MARK: - Initialize
    
    init(useCase: PlayUseCase) {
        self.useCase = useCase
    }
}

extension EndPlayViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.matchEndButtonTapEvent
            .subscribe(onNext: { [weak self] matchInput in
                print("😀matchInput, ", matchInput)
            guard let self = self else { return }
            self.useCase.patchEndMatch(request: matchInput)
        }).disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let endMatchStatusRelay = useCase.endMatchStatus
        let errorRelay = useCase.error

        endMatchStatusRelay.subscribe { model in
            print("😀 matchstatus:", model)
            output.endMatchStatus.accept(model)
        }.disposed(by: self.disposeBag)
        
        errorRelay.subscribe { error in
            print("EndPlayViewModel - error:", error)
            output.error.accept(())
        }.disposed(by: disposeBag)
    }
}
