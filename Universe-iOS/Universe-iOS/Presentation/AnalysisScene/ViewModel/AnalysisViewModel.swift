//
//  AnalysisViewModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/13.
//

import RxSwift
import RxRelay

final class AnalysisViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: AnalysisUseCase
    private let disposeBag = DisposeBag()
    let titleHeaderList = [I18N.Analysis.defaultInfo, I18N.Analysis.diagnosis]
    let subTitleHeaderList = [I18N.Analysis.all, I18N.Analysis.movement, I18N.Analysis.etc]
    let diagnosisList = [Diagnosis(icon: "W", title: "로브 방어 취약", description: "총 N회의 로브 공격에 대하여 N회 이상 실점함"),
                         Diagnosis(icon: "G", title: "스파이크 득점 우수", description: "총 N회의 스파이크 공격에 대하여 N회 이상 득점함"),
                         Diagnosis(icon: "G", title: "앵글 득점 우수", description: "총 N회의 앵글 공격에 대하여 N회 이상 득점함"),
                         Diagnosis(icon: "W", title: "코트아웃 실점", description: "경기 중 N회의 코트아웃으로 실점함")]
    
    // MARK: - Inputs
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var userInfoModel = PublishRelay<AnalysisUserInfoModel>()
        var myPlayModel = PublishRelay<CommunityModel?>()
        var basicStatModel = PublishRelay<BasicStatModel>()
        var pointStatModel = PublishRelay<[[GraphModel]]>()
        var error = PublishRelay<Error>()
    }
    
    // MARK: - Initialize
    
    init(useCase: AnalysisUseCase) {
        self.useCase = useCase
    }
}

extension AnalysisViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.useCase.getUserInfo()
                owner.useCase.getMyPlayInfo()
                owner.useCase.getBasicStat()
                owner.useCase.getPointStat()
            }.disposed(by: self.disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let userInfoRelay = useCase.userInfo
        let myPlayRelay = useCase.myPlay
        let basicStatRelay = useCase.basicStat
        let pointStatRelay = useCase.pointStat
        let errorRelay = useCase.error
        
        userInfoRelay.subscribe { model in
            output.userInfoModel.accept(model)
        }.disposed(by: self.disposeBag)
        
        myPlayRelay.subscribe { model in
            output.myPlayModel.accept(model)
        }.disposed(by: self.disposeBag)
        
        basicStatRelay.subscribe { model in
            output.basicStatModel.accept(model)
        }.disposed(by: self.disposeBag)
        
        pointStatRelay.subscribe { model in
            output.pointStatModel.accept(model)
        }.disposed(by: self.disposeBag)
        
        errorRelay.subscribe { error in
            output.error.accept(error)
        }.disposed(by: self.disposeBag)
    }
}
