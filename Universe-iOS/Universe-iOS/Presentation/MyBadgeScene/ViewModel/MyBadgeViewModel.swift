//
//  MyBadgeViewModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/25.
//

import RxSwift
import RxRelay

final class MyBadgeViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: BadgeUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var badgeLists = PublishRelay<[BadgeModel]>()
        var error = PublishRelay<Error>()
    }
    
    // MARK: - Initialize
    
    init(useCase: BadgeUseCase) {
        self.useCase = useCase
    }
}

extension MyBadgeViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.useCase.getMyBadgeList()
            }
            .disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let myBadgeListRelay = useCase.myBadgeList
        let errorRelay = useCase.error
        
        myBadgeListRelay.subscribe { model in
            output.badgeLists.accept(model)
        }.disposed(by: self.disposeBag)
        
        errorRelay.subscribe { error in
            output.error.accept(error)
        }.disposed(by: disposeBag)
    }
}
