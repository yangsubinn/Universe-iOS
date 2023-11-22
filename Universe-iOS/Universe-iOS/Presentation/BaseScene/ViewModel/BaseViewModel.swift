//
//  BaseViewModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import RxSwift

final class BaseViewModel: ViewModelType {
    
//    private let useCase: BaseUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    struct Input {
        
    }
    
    // MARK: - Outputs
    struct Output {
        
    }
    
//    init(useCase: BaseUseCase) {
//        self.useCase = useCase
//    }
}

extension BaseViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        
    }
}
