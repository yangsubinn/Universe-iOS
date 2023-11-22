//
//  LiveType.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/08.
//

import Foundation

@frozen
enum LiveType {
    case ingLive
    case ReplayLive
    
    var title: String {
        switch self {
        case .ingLive:
            return I18N.Community.ingLive
        case .ReplayLive:
            return I18N.Community.replayLive
        }
    }
}
