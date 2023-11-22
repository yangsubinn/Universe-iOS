//
//  showErrorAlert.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/02/14.
//

import UIKit

/**
 확인 버튼을 눌렀을때 alert를 닫는 것 외의 추가 액션이 필요한 경우,
 okAction에 넣어서 사용하시면 됩니다.
 */

extension UIViewController {
    func showErrorAlert(errortype: APIError, okAction: ((UIAlertAction) -> Void)? = nil) {
        makeAlert(title: errortype.title, message: errortype.message, okAction: okAction)
    }
}
