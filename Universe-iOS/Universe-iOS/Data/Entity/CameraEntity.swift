//
//  CameraEntity.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/02/14.
//

import Foundation

struct CameraEntity: Codable {
    let id, cameraNumber: Int
    let tennisVideoURL: String

    enum CodingKeys: String, CodingKey {
        case id, cameraNumber
        case tennisVideoURL = "tennisVideoUrl"
    }
    
    func toDomain() -> CameraModel {
        if let url = URL(string: tennisVideoURL) {
            return CameraModel(cameraNumber: cameraNumber, tennisVideoUrl: url)
        } else {
            return CameraModel(cameraNumber: cameraNumber, tennisVideoUrl: URL(string: ""))
        }
    }
}

typealias CameraListEntity = [CameraEntity]
