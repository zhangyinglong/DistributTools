//
//  AppInfo.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/5/31.
//  Copyright © 2017年 ChinaHR. All rights reserved.
//

import ObjectMapper
import RealmSwift

enum AppType: String {
    case ios = "1"
    case android = "2"
}

class AppInfo: Object, Mappable, IdentifyProtocol {
    
    var id = ""
    var appBuildVersion = ""
    var appCreated = ""
    var appDescription = ""
    var appFileSize = ""
    var appIcon = ""
    var appKey = ""
    var appName = ""
    var appScreenshots = ""
    var appType: AppType = .ios
    var appUpdateDescription = ""
    var appVersion = ""
    var appVersionNo = ""
    var appShortcutUrl = ""
    var appQRCodeURL = ""
    
    var isNeedUpdate = false
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["appIdentifier"]
        appBuildVersion <- map["appBuildVersion"]
        appCreated <- map["appCreated"]
        appDescription <- map["appDescription"]
        appFileSize <- map["appFileSize"]
        appIcon <- map["appIcon"]
        appKey <- map["appKey"]
        appName <- map["appName"]
        appScreenshots <- map["appScreenshots"]
        appType <- map["appType"]
        appUpdateDescription <- map["appUpdateDescription"]
        appVersion <- map["appVersion"]
        appVersionNo <- map["appVersionNo"]
        appShortcutUrl <- map["appShortcutUrl"]
        appQRCodeURL <- map["appQRCodeURL"]
    }
    
    public func iconUrl() -> URL? {
        return URL(string: PgyerModule.image_host + "/" + appIcon)
    }
    
    public func shortcutUrl() -> URL? {
        return URL(string: PgyerModule.host + "/" + appShortcutUrl)
    }
    
}

    
