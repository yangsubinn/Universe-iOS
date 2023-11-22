//
//  ViewModelType.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output
}
