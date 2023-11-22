//
//  ModuleFactory.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import UIKit

/*
 - 사용법:
 1) ModuelFactoryProtocol에 넘겨야할 VC를 메서드 형태로 정의만 한다.
 2) ModuleFactory를 extension해서 구현해야 할 부분을 직접 작성한다.
 controllerFromStoryboard(익스텐션)를 활용해서 인스턴스를 생성한다
 -> storyboard를 사용하지 않으면 가져오지 않고 뷰컨 자체를 가지고 오면 될 것 같다
 3) 각각 필요한 VC내에서 MoudleFactory를 가지고 뷰컨을 가져오면 끝!
 */

protocol ModuleFactoryProtocol {
    func makeBaseVC() -> BaseTabBarController
    func makeSplashNC() -> UINavigationController
    func makeLoginVC() -> LoginViewController
    func makeStadiumListVC() -> StadiumListViewController
    func makeStadiumDetailVC(isIng: Bool, stadiumId: Int?) -> StadiumDetailViewController
    func makePlayVC(_ playType: PlayType, type: PlayViewType, matchId: Int, matchInfo: MatchInfoModel?, matchScore: MatchScoreModel?) -> PlayViewController
    func makeEndPlayVC(isDone: Bool, matchId: Int) -> EndPlayViewController
    func makeStartPlayVC(viewModel: PlayViewModel) -> StartPlayViewController
    func makeAnalysisVC() -> AnalysisViewController
    func makeCommunityVC() -> CommunityViewController
    func makeMoreLiveVC(allLives: [CommunityModel], liveType: LiveType) -> MoreLiveViewController
    func makeMyProfileVC() -> MyProfileViewController
    func makeMyBadgeVC() -> MyBadgeViewController
    func makeBottomSheetVC(contentVC: UIViewController) -> BottomSheetViewController
    func makeAddPlayerVC(isPlaying: Bool, matchId: Int?, stadiumId: Int?, stadiumName: String) -> AddPlayerViewController
    func makePlayerListVC(list: [PlayerModel], teamType: TeamType) -> PlayerListViewController
    func makeMatchAnalysisVC() -> MatchAnalysisViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    static let shared = ModuleFactory()
    private init() { }
    
    let userService = UserService()
    let badgeService = BadgeService()
    let stadiumService = StadiumService()
    let videoService = VideoService()
    let matchService = MatchService()
    
    func makeSplashNC() -> UINavigationController {
        let splashNC = UINavigationController(rootViewController: SplashViewController())
        return splashNC
    }
    
    func makeLoginVC() -> LoginViewController {
        let repository = DefaultUserRepository(service: userService)
        let useCase = DefaultLoginUseCase(repository: repository)
        let viewModel = LoginViewModel(useCase: useCase)
        let loginVC = LoginViewController()
        loginVC.viewModel = viewModel
        return loginVC
    }
    
    func makeStadiumListVC() -> StadiumListViewController {
        let repository = DefaultStadiumRepository(service: stadiumService)
        let useCase = DefaultStadiumUseCase(repository: repository)
        let viewModel = StadiumViewModel(useCase: useCase)
        let stadiumListVC = StadiumListViewController()
        stadiumListVC.viewModel = viewModel
        return stadiumListVC
    }
    
    func makeStadiumDetailVC(isIng: Bool = false, stadiumId: Int? = 0) -> StadiumDetailViewController {
        let repository = DefaultStadiumRepository(service: stadiumService)
        let useCase = DefaultStadiumDetailUseCase(repository: repository)
        let viewModel = StadiumDetailViewModel(useCase: useCase)
        let stadiumDetailVC = StadiumDetailViewController()
        stadiumDetailVC.viewModel = viewModel
        stadiumDetailVC.isIng = isIng
        stadiumDetailVC.stadiumId = stadiumId
        return stadiumDetailVC
    }
    
    func makePlayVC(_ playType: PlayType, type: PlayViewType, matchId: Int, matchInfo: MatchInfoModel? = nil, matchScore: MatchScoreModel? = nil) -> PlayViewController {
        let repository = DefaultMatchRepository(service: matchService)
        let videoRepository = DefaultVideoRepository(service: videoService)
        let useCase = DefaultPlayUseCase(matchRepository: repository, videoRepository: videoRepository)
        let viewModel = PlayViewModel(useCase: useCase, matchId: matchId, matchInfo: matchInfo, matchScore: matchScore)
        let playVC = PlayViewController()
        playVC.playType = playType
        playVC.viewModel = viewModel
        playVC.type = type
        return playVC
    }
    
    func makeEndPlayVC(isDone: Bool, matchId: Int) -> EndPlayViewController {
        let repository = DefaultMatchRepository(service: matchService)
        let videoRepository = DefaultVideoRepository(service: videoService)
        let useCase = DefaultPlayUseCase(matchRepository: repository, videoRepository: videoRepository)
        let viewModel = EndPlayViewModel(useCase: useCase)
        let endPlayVC = EndPlayViewController()
        endPlayVC.viewModel = viewModel
        endPlayVC.isDone = isDone
        endPlayVC.matchId = matchId
        endPlayVC.modalTransitionStyle = .crossDissolve
        endPlayVC.modalPresentationStyle = .overFullScreen
        return endPlayVC
    }
    
    func makeStartPlayVC(viewModel: PlayViewModel) -> StartPlayViewController {
        let startPlayVC = StartPlayViewController()
        startPlayVC.viewModel = viewModel
        startPlayVC.modalTransitionStyle = .crossDissolve
        startPlayVC.modalPresentationStyle = .overFullScreen
        return startPlayVC
    }
    
    func makeAnalysisVC() -> AnalysisViewController {
        let userRepository = DefaultUserRepository(service: userService)
        let matchRepository = DefaultMatchRepository(service: matchService)
        let useCase = DefaultAnalysisUseCase(userRepository: userRepository, matchRepository: matchRepository)
        let viewModel = AnalysisViewModel(useCase: useCase)
        let analysisVC = AnalysisViewController()
        analysisVC.viewModel = viewModel
        return analysisVC
    }
    
    func makeCommunityVC() -> CommunityViewController {
        let repository = DefaultMatchRepository(service: matchService)
        let useCase = DefaultMatchUseCase(repository: repository)
        let viewModel = CommunityViewModel(useCase: useCase)
        let communityVC = CommunityViewController()
        communityVC.viewModel = viewModel
        return communityVC
    }
    
    func makeMoreLiveVC(allLives: [CommunityModel], liveType: LiveType) -> MoreLiveViewController {
        let repository = DefaultMatchRepository(service: matchService)
        let useCase = DefaultMatchUseCase(repository: repository)
        let viewModel = CommunityViewModel(useCase: useCase)
        let moreLiveVC = MoreLiveViewController()
        moreLiveVC.viewModel = viewModel
        moreLiveVC.contentModel = allLives
        moreLiveVC.liveType = liveType
        return moreLiveVC
    }
    
    func makeMyProfileVC() -> MyProfileViewController {
        let userRepository = DefaultUserRepository(service: userService)
        let badgeRepository = DefaultBadgeRepository(service: badgeService)
        let useCase = DefaultMyProfileUseCase(profileRepository: userRepository, badgeRepository: badgeRepository)
        let viewModel = MyProfileViewModel(useCase: useCase)
        let myProfileVC = MyProfileViewController()
        myProfileVC.viewModel = viewModel
        return myProfileVC
    }
    
    func makeBaseVC() -> BaseTabBarController {
        let baseVC = BaseTabBarController()
        return baseVC
    }
    
    func makeMyBadgeVC() -> MyBadgeViewController {
        let repository = DefaultBadgeRepository(service: badgeService)
        let useCase = DefaultBadgeUseCase(repository: repository)
        let viewModel = MyBadgeViewModel(useCase: useCase)
        let myBadgeVC = MyBadgeViewController()
        myBadgeVC.viewModel = viewModel
        return myBadgeVC
    }
    
    func makeBadgeDetailVC(badgeId: Int) -> BadgeDetailViewController {
        let repository = DefaultBadgeRepository(service: badgeService)
        let useCase = DefaultBadgeUseCase(repository: repository)
        let viewModel = BadgeDetailViewModel(useCase: useCase, badgeId: badgeId)
        let badgeDetailVC = BadgeDetailViewController()
        badgeDetailVC.viewModel = viewModel
        badgeDetailVC.modalTransitionStyle = .crossDissolve
        badgeDetailVC.modalPresentationStyle = .overFullScreen
        return badgeDetailVC
    }
    
    func makePlanVC() -> PlanViewController {
        let planVC = PlanViewController()
        return planVC
    }
    
    func makeBottomSheetVC(contentVC: UIViewController) -> BottomSheetViewController {
        let bottomSheet = BottomSheetViewController(contentViewController: contentVC)
        bottomSheet.modalPresentationStyle = .overFullScreen
        bottomSheet.modalTransitionStyle = .crossDissolve
        return bottomSheet
    }
    
    func makeAddPlayerVC(isPlaying: Bool, matchId: Int?, stadiumId: Int?, stadiumName: String) -> AddPlayerViewController {
        let matchRepository = DefaultMatchRepository(service: matchService)
        let userRepository = DefaultUserRepository(service: userService)
        let useCase = DefaultAddPlayerUseCase(matchRepository: matchRepository, userRepository: userRepository)
        let viewModel = AddPlayerViewModel(useCase: useCase, isPlaying: isPlaying, matchId: matchId, stadiumId: stadiumId, stadiumName: stadiumName)
        let addPlayerVC = AddPlayerViewController()
        addPlayerVC.viewModel = viewModel
        addPlayerVC.modalPresentationStyle = .fullScreen
        return addPlayerVC
    }
    
    func makePlayerListVC(list: [PlayerModel], teamType: TeamType) -> PlayerListViewController {
        let viewModel = PlayerListViewModel(playerList: list)
        let playerListVC = PlayerListViewController()
        playerListVC.viewModel = viewModel
        playerListVC.teamType = teamType
        return playerListVC
    }
    
    func makeMatchAnalysisVC() -> MatchAnalysisViewController {
        let repository = DefaultMatchRepository(service: matchService)
        let useCase = DefaultMatchUseCase(repository: repository)
        let viewModel = MatchAnalysisViewModel(useCase: useCase)
        let matchAnalysisVC = MatchAnalysisViewController()
        matchAnalysisVC.viewModel = viewModel
        return matchAnalysisVC
    }
}
