//
//  AppInformationService.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/19.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

import UIKit

let _AppInformationService_onceToken = NSUUID().uuidString
var _AppInformationService_instance: AppInformationService? = nil

class AppInformationService: NSObject {

    class func defaultService() -> AppInformationService {
        DispatchQueue.once(token: _AppInformationService_onceToken) {
            _AppInformationService_instance = AppInformationService()
        }
        return _AppInformationService_instance!
    }

    private override init() {
        super.init()

    }

    // 验证App短链接 http://www.pgyer.com/apiv1/app/getAppKeyByShortcut

    func getAppKeyByShortcut(shortcut: String,
        _api_key: String,
        success: ((URLSessionDataTask, AnyObject?) -> Void)?,
        failure: ((URLSessionDataTask?, NSError) -> Void)?)
    {
        RACHttpClient.defaultClient().POST(url: "http://www.pgyer.com/apiv1/app/getAppKeyByShortcut",
            parameters: [ "shortcut":shortcut, "_api_key":_api_key ],
            success: success,
            failure: failure)
    }

    // 获取发布的App列表 http://www.pgyer.com/apiv1/user/listMyPublished

    func listMyPublished(uKey: String,
        _api_key: String,
        page: Int,
        success: @escaping ((Array<AnyObject>) -> Void),
        failure: ((URLSessionDataTask?, NSError) -> Void)?)
    {
        RACHttpClient.defaultClient().POST(url: "http://www.pgyer.com/apiv1/user/listMyPublished",
            parameters: [ "uKey":uKey, "_api_key":_api_key, "page":page ],
            success: { (task, response) -> Void in
                var dataSource: Array<AnyObject> = Array()
                if let responseDic: NSDictionary = response as? NSDictionary {
                    let data: NSDictionary = responseDic["data"] as! NSDictionary
                    let list: NSArray = data["list"] as! NSArray
                    for item in list {
                        let appItem: AppUpdateModel = AppUpdateModel.yy_model(with: item as! [NSObject : AnyObject])!
                        let oldItem = AppUpdateModel.find(byColumn: "appIdentifier", value: appItem.appIdentifier).first
                        if (oldItem != nil) {
                            if (appItem.appBuildVersion > (oldItem! as AnyObject).appBuildVersion) {
                                appItem.setNeedUpdate(true)
                            } else {
                                appItem.isNeedUpdate = (oldItem! as AnyObject).isNeedUpdate
                            }
                        }
                        appItem.save()
                        dataSource.append(appItem)
                    }
                }
                success(dataSource)
            },
            failure: failure)
    }

    // 获取APP组信息 http://www.pgyer.com/apiv1/app/viewGroup

    func viewAppGroup(aId: String,
        _api_key: String,
        success: ((URLSessionDataTask, AnyObject?) -> Void)?,
        failure: ((URLSessionDataTask?, NSError) -> Void)?)
    {
        RACHttpClient.defaultClient().POST(url: "http://www.pgyer.com/apiv1/app/viewGroup",
            parameters: [ "aId":aId, "_api_key":_api_key ],
            success: success,
            failure: failure
        )
    }

    // 获取APP信息 http://www.pgyer.com/apiv1/app/view

    func viewAppInformation(aKey: String,
        uKey: String,
        _api_key: String,
        success: ((URLSessionDataTask, AnyObject?) -> Void)?,
        failure: ((URLSessionDataTask?, NSError) -> Void)?)
    {
        RACHttpClient.defaultClient().POST(url: "http://www.pgyer.com/apiv1/app/view",
            parameters: [ "aKey":aKey, "uKey":uKey, "_api_key":_api_key ],
            success: success,
            failure: failure
        )
    }

}
