//
//  VideoLinkEntity.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/02/13.
//

import Foundation

struct VideoLinkEntity: Codable {
    let uri: String
    
    func toDomain() -> VideoLinkModel {
        return VideoLinkModel(uri: URL(string: uri)!)
    }
}
