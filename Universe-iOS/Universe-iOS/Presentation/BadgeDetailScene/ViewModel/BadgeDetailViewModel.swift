//
//  BadgeDetailViewModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/05.
//

import RxSwift
import RxRelay

final class BadgeDetailViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: BadgeUseCase
    private let disposeBag = DisposeBag()
    private let badgeId: Int!
    
    // MARK: - Inputs
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var badgeDetailModel = PublishRelay<BadgeDetailModel>()
        var error = PublishRelay<Error>()
    }
    
    init(useCase: BadgeUseCase, badgeId: Int) {
        self.useCase = useCase
        self.badgeId = badgeId
    }
}

extension BadgeDetailViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.useCase.getBadgeDetail(badgeId: self.badgeId)
            }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let badgeDetailRelay = useCase.badgeDetailData
        // TODO: - 같은 useCase를 공유하는 두 뷰모델에서 error라는 한 스트림을 공유해도 될지 모르겠음
        let error = useCase.error
        
        badgeDetailRelay.subscribe { model in
            output.badgeDetailModel.accept(model)
        }.disposed(by: disposeBag)
        
        error.subscribe { error in
            output.error.accept(error)
        }.disposed(by: disposeBag)
    }
}
