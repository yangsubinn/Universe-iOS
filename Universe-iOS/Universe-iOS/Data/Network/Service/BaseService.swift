//
//  BaseService.swift
//  Universe-iOS
//
//  Created by Yi Joon Choi on 2023/01/02.
//

import Moya
import Alamofire
import RxSwift
import RxRelay
import RxCocoa

fileprivate class DefaultAlamofireManager: Alamofire.Session {
    static let shared: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

class BaseService <Target: TargetType> {
    typealias API = Target
    
    var disposeBag = DisposeBag()
    
    private lazy var provider: MoyaProvider<API> = {
        let provider = MoyaProvider<API>(endpointClosure: endpointClosure, session: DefaultAlamofireManager.shared)
        return provider
    }()
    
    private let endpointClosure = { (target: API) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        var endpoint: Endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        return endpoint
    }
    
    init() {}
}

extension BaseService {
    var `default`: BaseService {
        self.provider = provider
        return self
    }
    
    func requestObjectInRx<T: Decodable>(_ target: API) -> Observable<T?> {
        return Observable<T?>.create { observer in
            self.provider.rx
                .request(target)
                .subscribe { event in
                    switch event {
                    case .success(let value):
                        do {
                            let decoder = JSONDecoder()
                            let statusCode = value.statusCode
                            switch statusCode {
                            case 200, 201:
                                let body = try decoder.decode(ResponseObject<T>.self, from: value.data)
                                print("✅", body)
                                observer.onNext(body.data)
                                observer.onCompleted()
                            case 202:
                                // 유저 중복으로 인한 경기 생성 실패
                                let body = try decoder.decode(ResponseObject<DuplicatedUserEntity>.self, from: value.data)
                                if let duplicatedId = body.data?.duplicatedUserIDS {
                                    observer.onError(APIError.duplicatedUserErr(userId: duplicatedId))
                                } else {
                                    observer.onError(APIError.decodingErr)
                                }
                            case 400:
                                observer.onError(APIError.pathErr)
                            case 409:
                                observer.onError(APIError.duplicatedRequest)
                            case 404, 500:
                                observer.onError(APIError.serverErr)
                            default:
                                observer.onError(APIError.networkErr)
                            }
                        } catch let error {
                            dump(error)
                            observer.onError(error)
                        }
                    case .failure(let error):
                        dump(error)
                        observer.onError(error)
                    }
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func requestObject<T: Decodable>(_ target: API, completion: @escaping (Result<T?, Error>) -> Void) {
        provider.request(target) { response in
            switch response {
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(ResponseObject<T>.self, from: value.data)
                    completion(.success(body.data))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                switch error {
                case .underlying(let error, _):
                    if error.asAFError?.isSessionTaskError ?? false {
                        
                    }
                default: break
                }
                completion(.failure(error))
            }
        }
    }
    
    func requestArray<T: Decodable>(_ target: API, completion: @escaping (Result<[T], Error>) -> Void) {
        provider.request(target) { response in
            switch response {
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(ResponseObject<[T]>.self, from: value.data)
                    completion(.success(body.data ?? []))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                switch error {
                case .underlying(let error, _):
                    if error.asAFError?.isSessionTaskError ?? false {
                        
                    }
                default: break
                }
                completion(.failure(error))
            }
        }
    }
    
    func requestObjectWithNoResult(_ target: API, completion: @escaping (Result<Int?, Error>) -> Void) {
        provider.request(target) { response in
            switch response {
            case .success(let value):
                
                completion(.success(value.statusCode))
                
            case .failure(let error):
                switch error {
                case .underlying(let error, _):
                    if error.asAFError?.isSessionTaskError ?? false {
                        
                    }
                default: break
                }
                completion(.failure(error))
            }
        }
    }
    
    func requestObjectInRxWithNoResult(_ target: API) -> Observable<Int?> {
        return Observable.create { observer in
            self.provider.rx
                .request(target)
                .subscribe { event in
                    switch event {
                    case .success(let value):
                        let statusCode = value.statusCode
                        switch statusCode {
                        case 200, 201:
                            print("✅", value)
                            observer.onNext(statusCode)
                            observer.onCompleted()
                        case 202, 400:
                            observer.onError(APIError.pathErr)
                        case 409:
                            observer.onError(APIError.duplicatedRequest)
                        case 404, 500:
                            observer.onError(APIError.serverErr)
                        default:
                            observer.onError(APIError.networkErr)
                        }
                    case .failure(let error):
                        dump(error)
                        observer.onError(error)
                    }
                }
        }
    }
}
