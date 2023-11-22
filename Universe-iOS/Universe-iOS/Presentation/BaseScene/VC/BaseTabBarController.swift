//
//  BaseViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import UIKit
import UniverseKit
import Then
import RxSwift

class BaseTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let moduleFactory = ModuleFactory.shared
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbarUI()
        setTabbarProperty()
    }
}

extension BaseTabBarController {
    
    // MARK: - UI & Layout
    
    func setBackground() {
        self.view.backgroundColor = .white
    }
    
    private func setTabbarUI() {
        let tabBar: UITabBar = self.tabBar
        tabBar.backgroundColor = .white
        tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().isTranslucent = false
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
    
    private func setTabbarProperty() {
        viewControllers = [createFirstTab(), createSecondTab(), createThirdTab(), createFourthTab()]
        // 처음 선택된 VC 설정
        selectedIndex = 0
        selectedViewController = viewControllers?[0]
        
        // 탭바 아이템 가운데 정렬
        if let items = self.tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }
    
    // MARK: - Methods
    
    private func createFirstTab() -> UINavigationController {
        let firstNC = UINavigationController()
        let firstVC = ModuleFactory.shared.makeStadiumListVC()
        firstNC.addChild(firstVC)
        firstNC.tabBarItem.image = Icon.icBallInactive.image.withRenderingMode(.alwaysOriginal)
        firstNC.tabBarItem.selectedImage = Icon.icBallActive.image.withRenderingMode(.alwaysOriginal)
        
        return firstNC
    }
    
    private func createSecondTab() -> UINavigationController {
        let secondNC = UINavigationController()
        let secondVC = ModuleFactory.shared.makeAnalysisVC()
        secondNC.addChild(secondVC)
        secondNC.tabBarItem.image = Icon.icGraphInactive.image.withRenderingMode(.alwaysOriginal)
        secondNC.tabBarItem.selectedImage = Icon.icGraphActive.image.withRenderingMode(.alwaysOriginal)
        
        return secondNC
    }
    
    private func createThirdTab() -> UINavigationController {
        let thirdNC = UINavigationController()
        let thirdVC = ModuleFactory.shared.makeCommunityVC()
        thirdNC.addChild(thirdVC)
        thirdNC.tabBarItem.image = Icon.icTrophyInactive.image.withRenderingMode(.alwaysOriginal)
        thirdNC.tabBarItem.selectedImage = Icon.icTrophyActive.image.withRenderingMode(.alwaysOriginal)
        
        return thirdNC
    }
    
    private func createFourthTab() -> UINavigationController {
        let fourthNC = UINavigationController()
        let fourthVC = ModuleFactory.shared.makeMyProfileVC()
        fourthNC.addChild(fourthVC)
        fourthNC.tabBarItem.image = Icon.icMyInactive.image.withRenderingMode(.alwaysOriginal)
        fourthNC.tabBarItem.selectedImage = Icon.icMyActive.image.withRenderingMode(.alwaysOriginal)
        
        return fourthNC
    }
}
