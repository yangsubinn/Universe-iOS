//
//  StadiumViewModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/15.
//

import RxSwift
import RxRelay

final class StadiumViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: StadiumUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var ingStadium = PublishRelay<StadiumModel?>()
        var stadiumLists = PublishRelay<[StadiumModel]>()
    }
    
    // MARK: - Initialize
    
    init(useCase: StadiumUseCase) {
        self.useCase = useCase
    }
}

extension StadiumViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.useCase.getStadiumList()
        }).disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let stadiumListRelay = useCase.stadiumList
        let ingStadiumRelay = useCase.ingStadium
        
        stadiumListRelay.subscribe { model in
            output.stadiumLists.accept(model)
        }.disposed(by: self.disposeBag)
        
        ingStadiumRelay.subscribe { model in
            output.ingStadium.accept(model)
        }.disposed(by: self.disposeBag)
    }
}
