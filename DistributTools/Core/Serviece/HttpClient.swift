//
//  HttpClient.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/8.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

import Result
import Alamofire
import AlamofireNetworkActivityIndicator
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

typealias HttpCallBack = (Void) -> Void

class HttpClient {
    
//    static let defaultClient = AFHTTPSessionManager()
    static let shared = HttpClient()
    
    fileprivate lazy var reachabilityManager: NetworkReachabilityManager? = {
        let reachabilityManager = NetworkReachabilityManager(host: "www.baidu.com")
        reachabilityManager?.listener = { status in
            switch status {
            case .reachable:
                break
            default:
                break
            }
        }
        reachabilityManager?.startListening()
        NetworkActivityIndicatorManager.shared.isEnabled = true
        return reachabilityManager
    }()
    
    class func POST(url: String, parameters: Parameters?, completion: @escaping HttpCallBack) {
        do {
            try Alamofire.request(url.asURL(), method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { data in
                
                
                
                //            switch data.result {
                //                case .success(let jsonData):
                //
                ////                if let accessToken = Mapper<WechatAccessToken>().map(JSONObject: jsonData), accessToken.access_token != "", accessToken.openid != "" {
                ////                    completion(accessToken)
                ////                }
                //                case .failure( _):
                ////                completion(nil)
                //            }
            }
        } catch {
            
        }
        
//        defaultClient.post(url, parameters: parameters,
//            progress: { (progress) -> Void in
//                print("progress = ", progress)
//            }, success: { (task, response) -> Void in
//
//                if success != nil {
//                    success!(task, response as AnyObject?)
//                }
//            }) { (task, error) -> Void in
//
//                if failure != nil {
//                    failure!(task, error as NSError)
//                }
//            }
    }

}

//extension String: URLConvertible {
//    
//    func asURL() throws -> URL {
//        if let url = URL(string: self) {
//            return url
//        } else {
//            throw NSError(domain: "NetWork", code: 100, userInfo: nil)
//        }
//    }
//    
//}
