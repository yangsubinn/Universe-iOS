//
//  BottomSheetDelegate.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import Foundation

protocol BottomSheetDelegate: AnyObject {
    func dismissButtonTapped(completion: (() -> Void)?)
}
