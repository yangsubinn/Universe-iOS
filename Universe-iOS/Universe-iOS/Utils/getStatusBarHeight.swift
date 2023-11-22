//
//  getStatusBarHeight.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import UIKit

extension UIViewController {
    func getStatusBarHeight() -> CGFloat {
        let statusBarHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 44
        return statusBarHeight
    }
}
