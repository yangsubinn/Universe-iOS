//
//  TabbarIcon.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/03.
//

import UIKit
import UniverseKit

enum TabbarIconType {
    case stadium
    case analysis
    case community
    case myprofile
}

struct TabbarIconViewModel {
    var iconActive: UniverseKit.Icon
    var iconInActive: UniverseKit.Icon
    var viewController: UIViewController
}
