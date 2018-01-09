//
//  PgyerService.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/3/14.
//  Copyright © 2017年 zhang yinglong. All rights reserved.
//

import Moya
import ObjectMapper
import Result
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
    case listMyPublished(params: [String: Int])
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

extension PgyerAPI: HttpRequest {
    
    public var provider: Any {
#if DEBUG
        return MoyaProvider<PgyerAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
#else
        return MoyaProvider<PgyerAPI>(plugins: [NetworkLoggerPlugin(verbose: false)])
#endif
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
            params.forEach({ parameters[$0.key] = $0.value })
        case .viewGroup(let params):
            params.forEach({ parameters[$0.key] = $0.value })
        case .view(let params):
            params.forEach({ parameters[$0.key] = $0.value })
        case .getAppKeyByShortcut(let params):
            params.forEach({ parameters[$0.key] = $0.value })
        }
        return parameters
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
//        return JSONEncoding.default
    }
    
    public var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        } else {
            return .requestPlain
        }
    }
    
    public var sampleData: Data {
        return Data()
//        switch self {
//        case .downloadMoyaWebContent:
//            return animatedBirdData() as Data
//        }
    }
    
}
