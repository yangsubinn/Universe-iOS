//
//  MatchType.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/02/13.
//

import Foundation

@frozen
enum MatchType: String {
    case live
    case replay
    case mine
}

@frozen
enum MatchListType: String {
    case limited
    case all
    case single
}
