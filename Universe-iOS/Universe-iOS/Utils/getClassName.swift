//
//  getClassName.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import Foundation
import UIKit

/*
 - Description:
 
 각 VC,TVC,CVC의 className을 String으로 가져올 수 있도록 연산 프로퍼티를 설정합니다.
 요 값들은 나중에 Identifier에 잘 써먹을 수 있습니다
 */

extension NSObject {
    
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}
