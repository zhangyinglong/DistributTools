//
//  TargetTypeEx.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/5/27.
//  Copyright © 2017年 zhang yinglong. All rights reserved.
//

import Moya

extension TargetType {

    var url: URL {
        get {
            return baseURL.appendingPathComponent(path)
        }
    }
    
}
