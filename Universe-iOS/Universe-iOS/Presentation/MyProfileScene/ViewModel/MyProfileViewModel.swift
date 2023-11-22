//
//  MyProfileViewModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/03.
//

import RxSwift
import RxRelay

final class MyProfileViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: MyProfileUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    struct Output {
        var myProfileModel = PublishRelay<MyProfileModel>()
        var badgeListModel = PublishRelay<BadgeListModel>()
        var error = PublishRelay<Error>()
    }
    
    init(useCase: MyProfileUseCase) {
        self.useCase = useCase
    }
}

extension MyProfileViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.useCase.getMyProfileData()
                owner.useCase.getBadgeData()
            }
            .disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let myProfileRelay = useCase.myProfileInfo
        let badgeRelay = useCase.badgeList
        let errorRelay = useCase.error
        
        myProfileRelay.subscribe { model in
            output.myProfileModel.accept(model)
        }.disposed(by: self.disposeBag)
        
        badgeRelay.subscribe { model in
            output.badgeListModel.accept(model)
        }.disposed(by: self.disposeBag)
        
        errorRelay.subscribe { error in
            output.error.accept(error)
        }.disposed(by: self.disposeBag)
    }
}
