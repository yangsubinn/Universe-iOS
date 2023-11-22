//
//  manageObserverAction.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/10.
//

import Foundation

extension NSObject {
    func postObserverAction(_ keyName: NotiList, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: NotiList.makeNotiName(list: keyName), object: object, userInfo: userInfo)
    }
    
    func addObserverAction(_ keyName: NotiList, action: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: NotiList.makeNotiName(list: keyName),
                                               object: nil,
                                               queue: nil,
                                               using: action)
    }
    
    func removeObserverAction(_ keyName: NotiList) {
        NotificationCenter.default.removeObserver(self, name: NotiList.makeNotiName(list: keyName), object: nil)
    }
}
