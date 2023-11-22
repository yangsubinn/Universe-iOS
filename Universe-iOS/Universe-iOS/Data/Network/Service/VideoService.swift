//
//  VideoService.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

typealias VideoService = BaseService<VideoAPI>

protocol VideoServiceType {
    func getVideoLink(matchId: Int, cameraNumber: Int) -> Observable<VideoLinkEntity?>
    func getCameraList(matchId: Int) -> Observable<CameraListEntity?>
}

extension VideoService: VideoServiceType {
    func getVideoLink(matchId: Int, cameraNumber: Int) -> Observable<VideoLinkEntity?> {
        requestObjectInRx(.getVideoLink(matchId: matchId, cameraNumber: cameraNumber))
    }
    func getCameraList(matchId: Int) -> Observable<CameraListEntity?> {
        requestObjectInRx(.getCameraList(matchId: matchId))
    }
}
