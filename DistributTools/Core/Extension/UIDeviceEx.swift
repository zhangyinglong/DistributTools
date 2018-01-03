//
//  UIDeviceEx.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/22.
//  Copyright © 2016年 zhang yinglong. All rights reserved.
//

import UIKit
import KeychainSwift

var __g__deviceIdentifierID__: String = ""

extension UIDevice {
    
    static func deviceIdentifierID() -> String {
        if __g__deviceIdentifierID__ == "" {
            let keychain = KeychainSwift()
            keychain.synchronizable = true
            if let t = keychain.get("deviceIdentifierID") {
                __g__deviceIdentifierID__ = t
            } else {
                __g__deviceIdentifierID__ = Utility.getUUID()
                keychain.set(__g__deviceIdentifierID__, forKey: "deviceIdentifierID")
            }
        }
        return __g__deviceIdentifierID__
    }

    static func clearDeviceIdentifierID() {
        let keychain = KeychainSwift()
        keychain.synchronizable = true
        if let t = keychain.get("deviceIdentifierID") {
            keychain.delete("deviceIdentifierID")
        }
    }

}
