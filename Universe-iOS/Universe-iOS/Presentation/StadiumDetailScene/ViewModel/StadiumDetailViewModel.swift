//
//  StadiumDetailViewModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/02/01.
//

import RxSwift
import RxRelay

final class StadiumDetailViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: StadiumDetailUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Int>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var stadiumData = PublishRelay<StadiumDetailModel>()
        var stadiumThumbnails = PublishRelay<[String]>()
    }
    
    // MARK: - Initialize
    
    init(useCase: StadiumDetailUseCase) {
        self.useCase = useCase
    }
}

extension StadiumDetailViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(onNext: { [weak self] stadiumIdInput in
            guard let self = self else { return }
            self.useCase.getStadiumDetail(stadiumId: stadiumIdInput)
        }).disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let stadiumDataRelay = useCase.stadiumData
        let stadiumThumbnailsRelay = useCase.stadiumThumbnails
        
        stadiumDataRelay.subscribe { model in
            output.stadiumData.accept(model)
        }.disposed(by: self.disposeBag)
        
        stadiumThumbnailsRelay.subscribe { model in
            output.stadiumThumbnails.accept(model)
        }.disposed(by: self.disposeBag)
    }
}
