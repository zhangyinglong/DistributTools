//
//  Utility.swift
//  PuhuiDownloader
//
//  Created by zhangyinglong on 16/1/22.
//  Copyright © 2016年 普惠金融. All rights reserved.
//

import Foundation

class Utility: NSObject {

    static func getUUID() -> String {
        let UUID: CFUUID = CFUUIDCreate(kCFAllocatorDefault)
        let UUIDString: CFString = CFUUIDCreateString(kCFAllocatorDefault, UUID)
        let result: String = String(UUIDString)
//        CFRelease(UUID);
//        CFRelease(UUIDString);
        return result
    }

}
