//
//  SplashViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/03.
//

import UIKit
import Then
import UniverseKit

class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    private let moduleFactory = ModuleFactory.shared
    
    // MARK: - UI Components
    
    private let splashIcon = UIImageView().then {
        $0.image = Icon.logo.image
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        checkTokenState()
    }
    
}

extension SplashViewController {
    
    // MARK: Methods
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setLayout() {
        view.addSubview(splashIcon)
        splashIcon.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func pushToLogin() {
        let loginVC = moduleFactory.makeLoginVC()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.navigationController?.pushViewController(loginVC, animated: false)
        }
    }
    
    private func pushToBaseTBC() {
        let baseTBC = self.moduleFactory.makeBaseVC()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.navigationController?.changeRootViewController(baseTBC)
        }
    }
    
    private func checkTokenState() {
        let accessToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken)
        // TODO: 토큰 만료 분기처리 필요
        if accessToken != nil {
            pushToBaseTBC()
        } else {
            pushToLogin()
        }
    }
}
