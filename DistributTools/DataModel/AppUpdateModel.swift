//
//  AppUpdateModel.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/3/8.
//  Copyright © 2017年 ChinaHR. All rights reserved.
//

import ObjectMapper
import RealmSwift

class AppUpdateModel: Object, Mappable, IdentifyProtocol {
    
    var id: String = ""
    var appBuildVersion: Int32 = 0
    var appCreated: String? = nil
    var appDescription: String? = nil
    var appFileSize: Int64 = 0
    var appIcon: String? = nil
    var appKey: String? = nil
    var appName: String? = nil
    var appScreenshots: String? = nil
    var appType: Int32 = 0
    var appUpdateDescription: String? = nil
    var appVersion: String? = nil
    var appVersionNo: String? = nil
    var isNeedUpdate: Bool = false
    
    override var description: String {
        return ""
//        return "AppItemModel[id=\(id),name=\(name),code=\(code),url=\(url)]"
    }
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["appIdentifier"]
        appBuildVersion <- map["appBuildVersion"]
        appCreated <- map["appCreated"]
        appDescription <- map["appDescription"]
        appFileSize <- map["appFileSize"]
        appName <- map["appName"]
        appScreenshots <- map["appScreenshots"]
        appType <- map["appType"]
        appUpdateDescription <- map["appUpdateDescription"]
        appVersion <- map["appVersion"]
        appVersionNo <- map["appVersionNo"]
        isNeedUpdate <- map["isNeedUpdate"]
    }

}
