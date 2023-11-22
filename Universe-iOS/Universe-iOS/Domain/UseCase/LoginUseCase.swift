//
//  LoginUseCase.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/30.
//

import RxSwift
import RxRelay

protocol LoginUseCase {
    func postUserLogin(email: String, password: String)
    var loginData: PublishRelay<LoginModel> { get set }
    var loginError: PublishRelay<Error> { get set }
    var loginFail: PublishRelay<Error> { get set }
}

final class DefaultLoginUseCase {
    
    private let repository: UserRepository
    private let disposeBag = DisposeBag()
    
    var loginData = PublishRelay<LoginModel>()
    var loginError =  PublishRelay<Error>()
    var loginFail = PublishRelay<Error>()
    
    init(repository: UserRepository) {
        self.repository = repository
    }
}

extension DefaultLoginUseCase: LoginUseCase {
    func postUserLogin(email: String, password: String) {
        repository.postUserLogin(email: email, password: password)
            .filter { $0 != nil }
            .subscribe(with: self) { owner, entity in
                guard let entity = entity else { return }
                let model = entity.toDomain()
                // UserDefault에 저장
                UserDefaults.standard.setValue(model.accessToken, forKey: Const.UserDefaultsKey.accessToken)
                UserDefaults.standard.setValue(model.userId, forKey: Const.UserDefaultsKey.userId)
                owner.loginData.accept(model)
            } onError: { owner, error in
                if error as! APIError == APIError.pathErr {
                    owner.loginError.accept(error)
                } else {
                    owner.loginFail.accept(error)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
