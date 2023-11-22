//
//  LoginViewModel.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/30.
//

import RxSwift
import RxRelay

final class LoginViewModel: ViewModelType {
    
    // MARK: - Properties
    private let useCase: LoginUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    struct Input {
        let buttonTapEvent: Observable<LoginRequestModel>
    }
    
    // MARK: - Outputs
    struct Output {
        var loginModel = PublishRelay<LoginModel>()
        var loginError = PublishRelay<Error>()
        var loginFail = PublishRelay<Error>()
    }
    
    init(useCase: LoginUseCase) {
        self.useCase = useCase
    }
}

extension LoginViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.buttonTapEvent.subscribe(onNext: { [weak self] loginRequestModel in
            guard let self = self else { return }
            self.useCase.postUserLogin(email: loginRequestModel.email, password: loginRequestModel.password)
        })
        .disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let loginDataRelay = useCase.loginData
        let loginErrorRelay = useCase.loginError
        let loginFailRelay = useCase.loginFail
        
        loginDataRelay.subscribe { model in
            output.loginModel.accept(model)
        }.disposed(by: self.disposeBag)
        
        loginErrorRelay.subscribe { model in
            output.loginError.accept(model)
        }.disposed(by: self.disposeBag)
        
        loginFailRelay.subscribe { model in
            output.loginFail.accept(model)
        }.disposed(by: self.disposeBag)
    }
}
