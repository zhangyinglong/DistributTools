//
//  HttpClient.swift
//  DistributTools
//
//  Created by zhang yinglong on 2018/1/5.
//  Copyright © 2018年 ChinaHR. All rights reserved.
//

import Moya
import ObjectMapper
import Result

public protocol HttpRequest: TargetType {
    var provider: Any { get }
}

struct HttpResponse: Mappable {
    var code: Int64 = 0
    var message = ""
    var data: Any? = nil
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class HttpClient<T, E> where T: HttpRequest, E: Mappable {
    
    typealias ObjectCompletion = (Result<E, DistributToolsError>) -> Void
    typealias ArrayCompletion = (Result<[E], DistributToolsError>) -> Void
    typealias HttpProvider = MoyaProvider<T>
    
    // 请求单个数据
    class func request(_ target: T, completion: @escaping ObjectCompletion) {
        if let reachabilityManager = AppDelegate.shared.reachabilityManager, reachabilityManager.isReachable
        {
            guard let provider = target.provider as? HttpProvider else { return }
            
            provider.request(target, callbackQueue: DispatchQueue.main, progress: nil) { result in
                switch result {
                case .success(let response):
                    do {
                        // 过滤失败的 response
                        let resp = try response.filterSuccessfulStatusCodes()
                        // 解析 resp
                        let res: HttpResponse = try resp.mapObject(HttpResponse.self)
                        if let data = res.data, res.code == DistributToolsErrorCode.success.rawValue
                        {
                            // ORM 转换
                            if let object = Mapper<E>().map(JSONObject: data) {
                                completion(.success(object))
                            } else {
                                completion(.failure(DistributToolsError.error(.dataError)))
                            }
                        } else {
                            completion(.failure(DistributToolsError.error(.netError)))
                        }
                    } catch let error {
                        print("error = \(error.localizedDescription)")
                    }
                case .failure(let error):
                    completion(.failure(DistributToolsError.error(code: DistributToolsErrorCode.netError.rawValue, reason: error.response?.description)))
                }
            }
        } else {
            completion(.failure(DistributToolsError.error(.netError)))
        }
    }
    
    // 请求数组
    class func requestArray(_ target: T, completion: @escaping ArrayCompletion) {
        if let reachabilityManager = AppDelegate.shared.reachabilityManager, reachabilityManager.isReachable
        {
            guard let provider = target.provider as? HttpProvider else { return }
            
            provider.request(target, callbackQueue: DispatchQueue.main, progress: nil) { result in
                switch result {
                case .success(let response):
                    do {
                        // 过滤失败的 response
                        let resp = try response.filterSuccessfulStatusCodes()
                        // 解析 resp
                        let res: HttpResponse = try resp.mapObject(HttpResponse.self)
                        if res.code == DistributToolsErrorCode.success.rawValue,
                            let data = res.data as? NSDictionary,
                            let list = data["list"]
                        {
                            // ORM 转换
                            if let object = Mapper<E>().mapArray(JSONObject: list) {
                                completion(.success(object))
                            } else {
                                completion(.failure(DistributToolsError.error(.dataError)))
                            }
                        } else {
                            completion(.failure(DistributToolsError.error(.netError)))
                        }
                    } catch let error {
                        print("error = \(error.localizedDescription)")
                    }
                case .failure(let error):
                    completion(.failure(DistributToolsError.error(code: DistributToolsErrorCode.netError.rawValue, reason: error.response?.description)))
                }
            }
        } else {
            completion(.failure(DistributToolsError.error(.netError)))
        }
    }
    
}
