//
//  AppInfoList.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/5/31.
//  Copyright © 2017年 zhang yinglong. All rights reserved.
//

import ObjectMapper
import RxSwift

struct AppInfoList: Mappable {
    
    var list = [AppInfo]()
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        list <- map["list"]
    }
    
}

extension AppInfoList {
    
    public func sequence() -> Observable<[AppInfo]> {
        return Observable.just(list)
    }
    
}
