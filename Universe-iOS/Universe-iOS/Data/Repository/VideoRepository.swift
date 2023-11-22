//
//  VideoRepository.swift
//  Universe-iOS
//
//  Created by 양수빈 on 2023/01/26.
//

import RxSwift

protocol VideoRepository {
    func getVideoLink(matchId: Int, cameraNumber: Int) -> Observable<VideoLinkEntity?>
    func getCameraList(matchId: Int) -> Observable<CameraListEntity?>
}

final class DefaultVideoRepository {
    
    private let videoService: VideoServiceType
    private let disposeBag = DisposeBag()
    
    init(service: VideoService) {
        self.videoService = service
    }
}

extension DefaultVideoRepository: VideoRepository {
    func getVideoLink(matchId: Int, cameraNumber: Int) -> Observable<VideoLinkEntity?> {
        return videoService.getVideoLink(matchId: matchId, cameraNumber: cameraNumber)
    }
    
    func getCameraList(matchId: Int) -> Observable<CameraListEntity?> {
        return videoService.getCameraList(matchId: matchId)
    }
}
