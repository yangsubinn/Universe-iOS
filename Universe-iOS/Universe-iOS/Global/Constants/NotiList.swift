//
//  NotiList.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/10.
//

import Foundation

/**
 NotiList에 사용할 noti를 등록해주고,
 addObserverAction / postObserverAction / removeObserverAction에 넣어서 사용하시면 됩니다.
*/
enum NotiList: String {
    case dismissPlayerList
    case presentPlayVC
    case pushNotiTapped
    case popToStadiumListVC
    
    static func makeNotiName(list: Self) -> NSNotification.Name {
        return Notification.Name(String(describing: list))
    }
}
