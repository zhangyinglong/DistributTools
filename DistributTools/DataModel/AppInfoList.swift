//
//  AppInfoList.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/5/31.
//  Copyright © 2017年 ChinaHR. All rights reserved.
//

import ObjectMapper
import RealmSwift

class AppInfoList: Mappable {
    
    var list = [AppInfo]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        list <- map["list"]
    }
    
}
