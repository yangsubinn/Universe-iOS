//
//  addTapGesture.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/04.
//

import UIKit
/*
 사용법
 -뷰컨에 view가 있다면
 
 view.onTap {
 print("View Tapped")
 }
 */
extension UIView {
    private struct OnClickHolder {
        static var closure: () -> Void = {}
    }
    
    private var onClickClosure: () -> Void {
        get { return OnClickHolder.closure }
        set { OnClickHolder.closure = newValue }
    }
    
    func onTap(closure: @escaping () -> Void) {
        self.onClickClosure = closure
        
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickAction))
        addGestureRecognizer(tap)
    }
    
    @objc private func onClickAction() {
        onClickClosure()
    }
}
