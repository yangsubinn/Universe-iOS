//
//  BaseViewController.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/04.
//

/*
 네비게이션 바 애니메이션을 미리 구현해놓은 BaseVC 입니다.
 
 필요에 따라 상속 받아 쓰시면 됩니다.
 
 class 어쩌구ViewController: BaseViewController
 
 ex) viewDidLoad에
 setNavigationBar(title: "커뮤니티", type: .center)
 setTitleView(title: "커뮤니티")
 
 */

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: - UI Components
    
    private var navigationBar = CustomNavigationBar().then {
        $0.hideTitle(true)
    }
    var titleView = CustomNavigationBar()
    
    var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
    }
    
    var scrollViewContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleToFill
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setBaseLayout()
        setDelegate()
    }
    
}

extension BaseViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.scrollView.showsVerticalScrollIndicator = false
    }
    
    func setBaseLayout() {
        view.addSubviews([scrollView, navigationBar])
        scrollView.add(scrollViewContainerView)
        scrollViewContainerView.addSubviews([titleView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.centerX.leading.equalTo(self.view.safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints { make in
            make.centerX.top.leading.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        scrollViewContainerView.snp.makeConstraints { make in
            make.centerX.top.leading.equalToSuperview()
            make.bottom.equalTo(self.scrollView.snp.bottom)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view.snp.height).priority(.low)
        }
        titleView.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.top.equalToSuperview().inset(58)
        }
    }
    
    func setNavigationBar(title: String, type: NavigationType) {
        navigationBar.setNavibar(self, title: title, type: type)
    }
    
    func setTitleView(title: String) {
        titleView.setNavibar(self, title: title, type: .left)
    }
    
    // MARK: - Methods
    
    private func setDelegate() {
        scrollView.delegate = self
    }
}

// MARK: - UIScrollViewDelegate

extension BaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let location = scrollView.contentOffset.y
        switch location {
        case ...10:
            navigationBar.hideTitle(true)
            titleView.hideTitle(false)
        case 10...58:
            navigationBar.backgroundColor = UIColor.white.withAlphaComponent(location/58)
        case 58:
            navigationBar.showTitleWithAnimation()
            titleView.hideTitle(true)
        default:
            navigationBar.backgroundColor = .white
            navigationBar.hideTitle(false)
            titleView.hideTitle(true)
        }
    }
}
