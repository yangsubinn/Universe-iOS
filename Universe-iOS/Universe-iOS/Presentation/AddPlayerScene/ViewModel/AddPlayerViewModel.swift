//
//  AddPlayerViewModel.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import RxSwift
import RxRelay

final class AddPlayerViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let useCase: AddPlayerUseCase
    private let disposeBag = DisposeBag()
    private var homePlayerList: [PlayerModel] = []
    private var awayPlayerList: [PlayerModel] = []
    var originPlayerList: [PlayerModel] = []
    private var isPlaying: Bool = false
    private var matchId: Int?
    var stadiumId: Int?
    var stadiumName: String = ""
    var matchInfoModel: MatchInfoModel?
    var matchScoreModel: MatchScoreModel?
    
    // MARK: - Inputs
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let refreshPlayerList: Observable<Void>
        let tappedStartButton: Observable<MatchStartRequestModel>
    }
    
    // MARK: - Outputs
    
    struct Output {
        var isPlaying = PublishRelay<Bool>()
        var playerList = PublishRelay<[[PlayerModel]]>()
        var matchId = PublishRelay<Int>()
        var hasDuplicatedUser = PublishRelay<Bool>()
        var error = PublishRelay<Error>()
    }
    
    // MARK: - Initialize
    
    init(useCase: AddPlayerUseCase, isPlaying: Bool, matchId: Int?, stadiumId: Int?, stadiumName: String) {
        self.useCase = useCase
        self.isPlaying = isPlaying
        self.stadiumId = stadiumId
        self.matchId = matchId
        self.stadiumName = stadiumName
    }
}

extension AddPlayerViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewDidLoadEvent
            .subscribe(with: self) { owner, _ in
                output.isPlaying.accept(owner.isPlaying)
                if owner.isPlaying {
                    // 경기 중, 참여 중인 선수 목록 불러오기
                    if let matchId = owner.matchId {
                        print("matchId:", matchId)
                        owner.useCase.getMatchInfo(matchId: matchId)
                        owner.useCase.getMatchScore(matchId: matchId)
                        output.matchId.accept(matchId)
                    } else {
                        output.error.accept(APIError.pathErr)
                    }
                } else {
                    // 경기 X, 선수 추가
                    owner.useCase.getPlayerList()
                }
            }
            .disposed(by: self.disposeBag)
        
        input.refreshPlayerList
            .subscribe(with: self) { owner, _ in
                owner.resetPlayerList()
                output.playerList.accept([owner.homePlayerList, owner.awayPlayerList])
            }
            .disposed(by: disposeBag)
        
        input.tappedStartButton
            .subscribe(with: self) { owner, model in
                owner.useCase.postStartMatch(requestModel: model)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        let myInfoRelay = useCase.myInfo
        let playerListRelay = useCase.playerList
        let matchInfoRelay = useCase.matchInfo
        let matchScoreRelay = useCase.matchScoreInfo
        let matchIdRelay = useCase.matchId
        let duplicatedUserRelay = useCase.duplicatedUserId
        let errorRelay = useCase.error
        
        myInfoRelay
            .withUnretained(self)
            .subscribe { owner, model in
                owner.homePlayerList.append(model)
            }.disposed(by: self.disposeBag)
        
        playerListRelay
            .withUnretained(self)
            .subscribe { owner, model in
                owner.originPlayerList.append(contentsOf: model)
                output.playerList.accept([owner.homePlayerList, owner.awayPlayerList])
            }.disposed(by: self.disposeBag)
        
        matchInfoRelay
            .withUnretained(self)
            .subscribe { owner, model in
                owner.matchInfoModel = model
                output.playerList.accept([model.homePlayer, model.awayPlayer])
            }.disposed(by: disposeBag)
        
        matchScoreRelay
            .withUnretained(self)
            .subscribe { owner, model in
                owner.matchScoreModel = model
            }.disposed(by: self.disposeBag)
        
        matchIdRelay
            .withUnretained(self)
            .subscribe { owner, matchId in
            output.matchId.accept(matchId)
            owner.useCase.getMatchInfo(matchId: matchId)
        }.disposed(by: self.disposeBag)
        
        duplicatedUserRelay
            .withUnretained(self)
            .subscribe { owner, list in
                list.forEach {
                    owner.changeIsPlayingInOriginList(id: $0)
                }
                output.hasDuplicatedUser.accept(true)
            }.disposed(by: self.disposeBag)
        
        errorRelay.subscribe { error in
            output.error.accept(error)
        }.disposed(by: self.disposeBag)
    }
    
    func changeOriginList(id: Int, isSelected: Bool, team: TeamType?) {
        if let idx = originPlayerList.enumerated().filter({ $0.element.userId == id }).first {
            let origin = originPlayerList[idx.offset]
            let new = PlayerModel(userId: origin.userId,
                                  profileImage: origin.profileImage,
                                  userName: origin.userName,
                                  ntrp: origin.ntrp,
                                  isSelected: isSelected,
                                  team: team,
                                  isPlaying: origin.isPlaying)
            originPlayerList[idx.offset] = new
        }
    }
    
    func changeIsPlayingInOriginList(id: Int) {
        if let idx = originPlayerList.enumerated().filter({ $0.element.userId == id }).first {
            let origin = originPlayerList[idx.offset]
            let new = PlayerModel(userId: origin.userId,
                                  profileImage: origin.profileImage,
                                  userName: origin.userName,
                                  ntrp: origin.ntrp,
                                  isSelected: origin.isSelected,
                                  team: origin.team,
                                  isPlaying: true)
            originPlayerList[idx.offset] = new
        } else if id == homePlayerList[0].userId {
            let origin = self.homePlayerList[0]
            self.homePlayerList[0] = PlayerModel(userId: origin.userId,
                                                 profileImage: origin.profileImage,
                                                 userName: origin.userName,
                                                 ntrp: origin.ntrp,
                                                 isSelected: true,
                                                 team: .home,
                                                 isPlaying: true)
        }
    }
    
    private func resetPlayerList() {
        if homePlayerList.count > 1 {
            homePlayerList.removeSubrange(1...)
        }
        awayPlayerList.removeAll()
        for player in self.originPlayerList {
            switch player.team {
            case .home:
                homePlayerList.append(player)
            case .away:
                awayPlayerList.append(player)
            default:
                break
            }
        }
    }
}
