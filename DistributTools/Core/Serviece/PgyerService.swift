//
//  PgyerService.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/3/14.
//  Copyright © 2017年 zhang yinglong. All rights reserved.
//

import Moya
import ObjectMapper
import Dispatch
import RxSwift

struct PgyerModule {
    public static let downloadUrl: String = "http://www.pgyer.com/FLhK"
    public static let host: String = "http://www.pgyer.com"
    public static let image_host: String = "http://7kttjt.com1.z0.glb.clouddn.com/image/view/app_icons/"
    
    /// 设置蒲公英参数
    public static let api_key: String = "2ec26f59f7cbdd95836875f30d35e588"
    public static let uKey: String = "58e6fe9f0435618fa635b31ece23c117"
    public static let aId: String = ""
    public static let aKey: String = ""
}

public enum PgyerAPI {
    case listMyPublished(params: [String: Any])
    case viewGroup(params: [String: Any])
    case view(params: [String: Any])
    case getAppKeyByShortcut(params: [String: Any])
}

extension PgyerAPI: CustomStringConvertible {
    public var description: String {
        switch self {
            case .listMyPublished: return "listMyPublished"
            case .viewGroup: return "viewGroup"
            case .view: return "view"
            case .getAppKeyByShortcut: return "getAppKeyByShortcut"
        }
    }
}

extension PgyerAPI: TargetType {

    public var baseURL: URL { return URL(string: "http://www.pgyer.com")! }
    
    public var path: String {
        switch self {
        case .listMyPublished(_):
            return "/apiv1/user/listMyPublished"
        case .viewGroup(_):
            return "/apiv1/app/viewGroup"
        case .view(_):
            return "/apiv1/app/view"
        case .getAppKeyByShortcut(_):
            return "/apiv1/app/getAppKeyByShortcut"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .listMyPublished(_):
            return .post
        case .viewGroup(_):
            return .post
        case .view(_):
            return .post
        case .getAppKeyByShortcut(_):
            return .post
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var parameters: [String: Any]? {
        var parameters: [String: Any] = [ "uKey":PgyerModule.uKey, "_api_key":PgyerModule.api_key ]
        switch self {
        case .listMyPublished(let params):
            for (key, value) in params {
                parameters[key] = value
            }
        case .viewGroup(let params):
            for (key, value) in params {
                parameters[key] = value
            }
        case .view(let params):
            for (key, value) in params {
                parameters[key] = value
            }
        case .getAppKeyByShortcut(let params):
            for (key, value) in params {
                parameters[key] = value
            }
        }
        return parameters
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        } else {
            return .requestPlain
        }
        
//        switch self {
//        case .listMyPublished(_):
//            return .request
//        case .viewGroup(_):
//            return .request
//        case .view(_):
//            return .request
//        case .getAppKeyByShortcut(_):
//            return .request
//        }
    }
    
    public var sampleData: Data {
        return Data()
//        switch self {
//        case .downloadMoyaWebContent:
//            return animatedBirdData() as Data
//        }
    }
    
}

extension PgyerAPI {

#if DEBUG
    static let PgyerProvider = MoyaProvider<PgyerAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
#else
    static let PgyerProvider = MoyaProvider<PgyerAPI>(plugins: [NetworkLoggerPlugin(verbose: false)])
#endif
    
    private static let queue = DispatchQueue(label: "PgyerAPI")
    
    static func request<T: Mappable>(_ target: PgyerAPI,
                        provider: MoyaProvider<PgyerAPI>? = nil,
                        success successClosure: @escaping (T) -> Void,
                        failure failureClosure: @escaping (DistributToolsError) -> Void)
    {
        if let reachabilityManager = AppDelegate.shared.reachabilityManager, reachabilityManager.isReachable {
            let tprovider = provider ?? PgyerProvider
            tprovider.request(target, callbackQueue: queue) { event in
                switch event {
                case let .success(response):
                    do {
                        // 过滤失败的 response
                        let resp = try response.filterSuccessfulStatusCodes()
    
                        // 解析 resp
                        let JSON = try resp.mapJSON() as! NSDictionary
                        let code = JSON["code"] as! Int64
                        let message = JSON["message"] as! String
                        let data = JSON["data"]
                        if code == Int64(0) {
                            // 缓存 resp
//                            if let urlResponse = resp.response,
//                                let urlRequest = resp.request {
//                                let cachedURLResponse = CachedURLResponse(response: urlResponse, data: resp.data, userInfo: nil, storagePolicy: .allowed)
//                                URLCache.shared.storeCachedResponse(cachedURLResponse, for: urlRequest)
//                            }
//                            
                            // ORM 转换
                            if let object = Mapper<T>().map(JSONObject: data) {
                                main_async({ 
                                    successClosure(object)
                                })
                            } else {
                                main_async({
                                    failureClosure(DistributToolsError.error(code: code, reason: message))
                                })
                            }
                        } else {
                            main_async({
                                failureClosure(DistributToolsError.error(code: code, reason: message))
                            })
                        }
                    } catch {

                    }
                case let .failure(error):
                    main_async({
                        failureClosure(DistributToolsError.error(code: DistributToolsErrorCode.netError.rawValue, reason: error.localizedDescription))
                    })
                }
            }
        } else {
            failureClosure(DistributToolsError.error(code: DistributToolsErrorCode.netError.rawValue, reason: "no network"))
            
//            var request = URLRequest(url: target.url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
//            request.addValue("private", forHTTPHeaderField: "Cache-Control")
//            // CachedURLResponse
//            if let response = URLCache.shared.cachedResponse(for: request) {
//                do {
//                    // 解析 resp
//                    let JSON = try response.mapJSON() as! NSDictionary
//                    let code = JSON["code"] as! Int64
//                    let message = JSON["message"] as! String
//                    let data = JSON["data"]
//                    if code == Int64(0) {
//                        // ORM 转换
//                        if let object = Mapper<T>().map(JSONObject: data) {
//                            successClosure(object)
//                        } else {
//                            failureClosure(DistributToolsError.error(code: code, reason: message))
//                        }
//                    } else {
//                        failureClosure(DistributToolsError.error(code: code, reason: message))
//                    }
//                } catch {
//                    
//                }
//            } else {
//                failureClosure(DistributToolsError.error(code: DistributToolsErrorCode.netError.rawValue, reason: "no cache"))
//            }
        }
    }
    
    static func requestArray<T: Mappable>(_ target: PgyerAPI,
                             provider: MoyaProvider<PgyerAPI>? = nil,
                             success successClosure: @escaping ([T]) -> Void,
                             failure failureClosure: @escaping (DistributToolsError) -> Void)
    {
        if let reachabilityManager = AppDelegate.shared.reachabilityManager, reachabilityManager.isReachable {
            let tprovider = provider ?? PgyerProvider
            tprovider.request(target, callbackQueue: queue) { event in
                switch event {
                case let .success(response):
                    do {
                        // 过滤失败的 response
                        let resp = try response.filterSuccessfulStatusCodes()
                        
                        // 解析 resp
                        let JSON = try resp.mapJSON() as! NSDictionary
                        let code = JSON["code"] as! Int64
                        let message = JSON["message"] as! String
                        let data = JSON["data"]
                        if code == Int64(0) {
                            // 缓存 resp
//                            if let urlResponse = resp.response,
//                                let urlRequest = resp.request {
//                                let cachedURLResponse = CachedURLResponse(response: urlResponse, data: resp.data, userInfo: nil, storagePolicy: .allowed)
//                                URLCache.shared.storeCachedResponse(cachedURLResponse, for: urlRequest)
//                            }
                            
                            // ORM 转换
                            if let array = Mapper<T>().mapArray(JSONObject: data) {
                                main_async({
                                    successClosure(array)
                                })
                            } else {
                                main_async({
                                    failureClosure(DistributToolsError.error(code: code, reason: message))
                                })
                            }
                        } else {
                            main_async({
                                failureClosure(DistributToolsError.error(code: code, reason: message))
                            })
                        }
                    } catch {

                    }
                case let .failure(error):
                    main_async({
                        failureClosure(DistributToolsError.error(code: DistributToolsErrorCode.netError.rawValue, reason: error.localizedDescription))
                    })
                }
            }
        } else {
            failureClosure(DistributToolsError.error(code: DistributToolsErrorCode.netError.rawValue, reason: "no network"))
//            var request = URLRequest(url: target.url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
//            request.addValue("private", forHTTPHeaderField: "Cache-Control")
//            // CachedURLResponse
//            if let response = URLCache.shared.cachedResponse(for: request) {
//                do {
//                    // 解析 resp
//                    let JSON = try response.mapJSON() as! NSDictionary
//                    let code = JSON["code"] as! Int64
//                    let message = JSON["message"] as! String
//                    let data = JSON["data"]
//                    if code == Int64(0) {
//                        // ORM 转换
//                        if let array = Mapper<T>().mapArray(JSONObject: data) {
//                            successClosure(array)
//                        } else {
//                            failureClosure(DistributToolsError.error(code: code, reason: message))
//                        }
//                    } else {
//                        failureClosure(DistributToolsError.error(code: code, reason: message))
//                    }
//                } catch {
//                    
//                }
//            } else {
//                failureClosure(DistributToolsError.error(code: DistributToolsErrorCode.netError.rawValue, reason: "no cache"))
//            }
        }
    }
    
}

//extension PgyerAPI {
//    
//#if DEBUG
//    static let rx_provider = RxMoyaProvider<PgyerAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
//#else
//    static let rx_provider = RxMoyaProvider<PgyerAPI>(plugins: [NetworkLoggerPlugin(verbose: false)])
//#endif
//    
//    private static let disposeBag = DisposeBag()
//    private static let queue = DispatchQueue(label: "PgyerAPI")
//    
////    static func rx_request<T: Mappable>(_ token: PgyerAPI,
////                           success successClosure: @escaping (T) -> Void,
////                           failure failureClosure: @escaping (DistributToolsError) -> Void)
////    {
////        rx_provider.request(token)
////            .filterSuccessfulStatusCodes()
////            .mapJSON().subscribe(onNext: { reps in
////                let JSON = reps as! NSDictionary
////                let code = JSON["code"] as! Int64
////                let message = JSON["message"] as! String
////                let data = JSON["data"]
////                if code == Int64(0) {
////                    // ORM 转换
////                    if let object = Mapper<T>().map(JSONObject: data) {
////                        successClosure(object)
////                    } else {
////                        failureClosure(DistributToolsError.error(code: code, reason: message))
////                    }
////                } else {
////                    failureClosure(DistributToolsError.error(code: code, reason: message))
////                }
////            }, onError: { error in
////                failureClosure(DistributToolsError.error(code: DistributToolsErrorCode.netError.rawValue, reason: error.localizedDescription))
////            }, onCompleted: { 
////                
////            }, onDisposed: { 
////                
////            }).addDisposableTo(disposeBag)
////    }
//    
//    static func rx_request<T: Mappable>(_ token: PgyerAPI) -> Observable<T> {
//        return rx_provider.request(token).filterSuccessfulStatusCodes().mapJSON().debug().mapObject(type: T.self)
//    }
//    
//    static func rx_requestArray<T: Mappable>(_ token: PgyerAPI) -> Observable<[T]> {
//        return rx_provider.request(token)
//            .filterSuccessfulStatusCodes()
//            .mapJSON()
//            .debug()
////            .mapArray(type: Mappable.Protocol)
//            .flatMap { item -> ObservableConvertibleType in
//            print(item)
//            return item
//        }
//        
////        return rx_provider.request(token).filterSuccessfulStatusCodes().mapJSON().debug().mapArray(type: T.self)
//    }
//
//}

