//
//  PaymentType.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/06.
//

import Foundation

@frozen
enum PaymentType: String {
    case card = "카드"
    case virtualAccount = "가상계좌"
    case accountTransfer = "계좌이체"
    
    static let allCases: [PaymentType] = [.card, .virtualAccount, .accountTransfer]
}
