//
//  AddPlayerDelegate.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/09.
//

import Foundation

protocol AddPlayerDelegate: AnyObject {
    func addButtonTapped(teamType: TeamType)
}
