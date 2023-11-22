//
//  PlayType.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/26.
//

import Foundation

@frozen
enum PlayType: String {
    case live
    case replay
}

@frozen
enum PlayViewType: String {
    case enableControl
    case disableControl
}
