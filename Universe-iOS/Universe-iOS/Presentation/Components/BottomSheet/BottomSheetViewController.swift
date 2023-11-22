//
//  BottomSheetViewController.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    private let contentVC: UIViewController
    private let dimmerView = UIView()
    private let bottomSheetView = UIView()
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    private var height: CGFloat = UIScreen.main.bounds.width * 361 / 375
    
    // MARK: - Initialize
    
    init(contentViewController: UIViewController) {
        self.contentVC = contentViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showBottomSheet()
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .clear
        dimmerView.backgroundColor = .black.withAlphaComponent(0.6)
        dimmerView.alpha = 0.6
        
        addChild(contentVC)
        bottomSheetView.addSubview(contentVC.view)
        contentVC.didMove(toParent: self)
        
        bottomSheetView.backgroundColor = .clear
        bottomSheetView.layer.cornerRadius = 20
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetView.clipsToBounds = true
    }
    
    private func setLayout() {
        view.addSubviews([dimmerView, bottomSheetView])
        
        dimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(topConstant)
        }
        self.view.layoutIfNeeded()
        
        contentVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    private func setTapGesture() {
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        dimmerView.addGestureRecognizer(dimmerTap)
        dimmerView.isUserInteractionEnabled = true
    }
    
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let statusBarHeight: CGFloat = getStatusBarHeight()
        let topConstant = safeAreaHeight - statusBarHeight - height
        
        bottomSheetView.snp.updateConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(topConstant)
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack(completion: (() -> Void)? = nil) {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        let topConstant = safeAreaHeight + bottomPadding
        bottomSheetView.snp.updateConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(topConstant)
            make.bottom.equalToSuperview().offset(topConstant)
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.dimmerView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: {_ in
            if self.presentingViewController != nil {
                self.dismiss(animated: true, completion: completion)
            }
        })
    }
    
    // MARK: - @objc
    
    @objc
    private func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
}

extension BottomSheetViewController: BottomSheetDelegate {
    func dismissButtonTapped(completion: (() -> Void)?) {
        hideBottomSheetAndGoBack(completion: completion)
    }
}
