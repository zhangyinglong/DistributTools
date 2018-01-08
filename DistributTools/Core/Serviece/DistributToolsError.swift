//
//  DistributToolsError.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/3/8.
//  Copyright © 2017年 zhang yinglong. All rights reserved.
//

enum DistributToolsErrorCode: Int64 {
    case success =      0
    case unreachable =  1000000
    case netError =     1000001
    case dataError =    1000002
}

extension DistributToolsErrorCode: CustomStringConvertible {
    var description: String {
        switch self {
        case .success:          return NSLocalizedString("success", comment: "success")
        case .unreachable:      return NSLocalizedString("unreachable", comment: "unreachable")
        case .netError:         return NSLocalizedString("netError", comment: "netError")
        case .dataError:        return NSLocalizedString("dataError", comment: "dataError")
        }
    }
}

struct DistributToolsError: Error {
    var code: Int64 = 0
    var langauge = "CN"
    var reason = ""
}

extension DistributToolsError: CustomNSError {
    static var errorDomain: String { return "distributTools" }
    
    /// The error code within the given domain.
    var errorCode: Int64 { return code }
    
    /// The user-info dictionary.
    var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: langauge, NSLocalizedFailureReasonErrorKey: reason]
    }
}

extension DistributToolsError: CustomStringConvertible {
    
    var description: String {
        return "DistributToolsError[code=\(code),langauge=\(langauge),reason=\(reason)]"
    }
    
}

extension DistributToolsError {
    
    static func error(code: Int64, reason: String?) -> DistributToolsError {
        return DistributToolsError(code: code, langauge: "CN", reason: (reason ?? "unknown error"))
    }
    
    static func error(_ code: DistributToolsErrorCode) -> DistributToolsError {
        return DistributToolsError.error(code: code.rawValue, reason: code.description)
    }
    
}
