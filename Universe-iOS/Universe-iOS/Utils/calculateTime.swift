//
//  calculateTime.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/17.
//

import Foundation

func calculateTime(sec: Int) -> String {
    let hour = sec / 3600
    let minute = (sec % 3600) / 60
    let second = (sec % 3600) % 60
    return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
}
