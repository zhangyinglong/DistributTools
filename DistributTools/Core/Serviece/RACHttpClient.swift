//
//  RACHttpClient.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/8.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

import UIKit
import AFNetworking

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

let _RACHttpClient_onceToken = NSUUID().uuidString
var _RACHttpClient_instance: RACHttpClient? = nil

class RACHttpClient: NSObject {

    private let manager: AFHTTPSessionManager!

    class func defaultClient() -> RACHttpClient {
        DispatchQueue.once(token: _RACHttpClient_onceToken) {
            _RACHttpClient_instance = RACHttpClient()
        }
        return _RACHttpClient_instance!;
    }

    private override init() {
        manager = AFHTTPSessionManager()
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
    }

    internal func POST(url: String,
                parameters: Any?,
                   success: ((URLSessionDataTask, AnyObject?) -> Void)?,
                   failure: ((URLSessionDataTask?, NSError) -> Void)?)
    {
        manager.post(url, parameters: parameters,
            progress: { (progress) -> Void in
                print("progress = ", progress)
            }, success: { (task, response) -> Void in

                if success != nil {
                    success!(task, response as AnyObject?)
                }
            }) { (task, error) -> Void in

                if failure != nil {
                    failure!(task, error as NSError)
                }
            }
    }

}
