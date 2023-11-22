//
//  UIView+Extension.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import UIKit
extension UIView {
    func addSubviews(_ view: [UIView]) {
        view.forEach { self.addSubview($0) }
    }
    @discardableResult
    func add<T: UIView>(_ subview: T,
                        then closure: ((T) -> Void)? = nil) -> T {
        addSubview(subview)
        closure?(subview)
        return subview
    }
    
    @discardableResult
    func adds<T: UIView>(_ subviews: [T],
                         then closure: (([T]) -> Void)? = nil) -> [T] {
        subviews.forEach { addSubview($0) }
        closure?(subviews)
        return subviews
    }
    func setRounded(radius: CGFloat?) {
        // UIView 의 모서리가 둥근 정도를 설정
        if let cornerRadius = radius {
            self.layer.cornerRadius = cornerRadius
        } else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        
        self.layer.masksToBounds = true
    }
    /// 부모뷰 찾기
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
