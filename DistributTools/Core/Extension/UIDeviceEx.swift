//
//  UIDeviceEx.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/22.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

import UIKit
import KeychainAccess

var __g__deviceIdentifierID__: String = ""

extension UIDevice {

    static func deviceIdentifierID() ->  String {
        if __g__deviceIdentifierID__ == "" {
            let keychain: Keychain = Keychain()
            let t = try! keychain.contains("deviceIdentifierID")
            if t {
                __g__deviceIdentifierID__ = keychain["deviceIdentifierID"]!
            } else {
                __g__deviceIdentifierID__ = Utility.getUUID()
                keychain["deviceIdentifierID"] = __g__deviceIdentifierID__
                _ = keychain.synchronizable(true)
            }
        }
        return __g__deviceIdentifierID__
    }

    static func clearDeviceIdentifierID() {
        let keychain: Keychain = Keychain()
        let t = try! keychain.contains("deviceIdentifierID")
        if t {
            try! keychain.remove("deviceIdentifierID")
        }
    }

}
