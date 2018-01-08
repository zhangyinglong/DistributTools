//
//  Theme.swift
//  DistributTools
//
//  Created by zhang yinglong on 2018/1/5.
//  Copyright © 2018年 ChinaHR. All rights reserved.
//

import ObjectMapper

private var global_colors = [String: ThemeColor]()
//private var global_fonts = [String: ThemeFont]()

struct ThemeColor: Mappable {
    
    var hex = ""
    var alpha: CGFloat = 1.0
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        hex <- map["hex"]
        alpha <- map["alpha"]
    }
    
    var color: UIColor {
        if hex.isEmpty {
            return UIColor.clear
        } else {
            return UIColor(hexStr: hex, alpha: alpha)
        }
    }
}

//struct ThemeFont: Mappable {
//
//    var hex = ""
//    var alpha: CGFloat = 1.0
//
//    init?(map: Map) {
//    }
//
//    mutating func mapping(map: Map) {
//        hex <- map["hex"]
//        alpha <- map["alpha"]
//    }
//
//    var color: UIColor {
//        if hex.isEmpty {
//            return UIColor.clear
//        } else {
//            return UIColor(hexStr: hex, alpha: alpha)
//        }
//    }
//}

public class Theme {
    
    class func color(_ key: String) -> UIColor {
        if let themeColor = global_colors[key] {
            return themeColor.color
        } else {
            return UIColor.black
        }
    }
    
//    class func font(_ key: String) -> UIFont {
//        if let themeColor = global_colors[key] {
//            return themeColor.color
//        } else {
//            return UIColor.black
//        }
//    }

}
