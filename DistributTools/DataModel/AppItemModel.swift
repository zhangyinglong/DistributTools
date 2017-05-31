//
//  AppItemModel.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/3/7.
//  Copyright © 2017年 ChinaHR. All rights reserved.
//

import ObjectMapper
import AlamofireObjectMapper
import RealmSwift
import SwiftyUserDefaults

class AppItemModel: Object, Mappable, IdentifyProtocol {
    
    var id: String = ""
    var appUpdateModel: AppUpdateModel? = nil;
    var image: UIImage? = nil
    
    override var description: String {
        return ""
//        return "AppItemModel[id=\(id),name=\(name),code=\(code),url=\(url)]"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        appUpdateModel <- map["AppUpdateModel"]
        image <- map["image"]
    }
    
    func setNeedUpdate(need: Bool) {
        
    }
    
}
