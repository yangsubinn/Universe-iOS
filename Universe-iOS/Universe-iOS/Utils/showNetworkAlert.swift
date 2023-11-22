//
//  makeAlert.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/27.
//

import UIKit

extension UIViewController {
    func showNetworkAlert(okAction: ((UIAlertAction) -> Void)? = nil) {
        makeAlert(title: I18N.Error.networkError, message: I18N.Error.networkErrorDescription, okAction: okAction)
    }
}
