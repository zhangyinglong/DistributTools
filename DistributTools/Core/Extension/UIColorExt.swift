//
//  UIColorExt.swift
//  LiveCap
//
//  Created by LuanMa on 16/3/3.
//  Copyright © 2016年 FunPlus. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	var rgba: String {
		get {
			var red: CGFloat = 0
			var green: CGFloat = 0
			var blue: CGFloat = 0
			var alpha: CGFloat = 0

			self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

			return "#" + String(format: "%02X", Int(255 * red)) + String(format: "%02X", Int(255 * green)) + String(format: "%02X", Int(255 * blue)) + String(format: "%02X", Int(255 * alpha))
		}
	}

	public convenience init(rgba: String, alpha: CGFloat) {
		let percent = 255 * alpha / 100
		let st = NSString(format: "%02X", Int(floor(percent)))

		self.init(rgba: "\(rgba)\(st)")
	}

	public convenience init(rgba: String) {
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 1.0

		if rgba.hasPrefix("#") {
			let index = rgba.index(rgba.startIndex, offsetBy: 1)
			let hex = rgba.substring(from: index)
			let scanner = Scanner(string: hex)
			var hexValue: CUnsignedLongLong = 0
			if scanner.scanHexInt64(&hexValue) {
				switch (hex.count) {
				case 3:
					red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
					green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
					blue = CGFloat(hexValue & 0x00F) / 15.0
				case 4:
					red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
					green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
					blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
					alpha = CGFloat(hexValue & 0x000F) / 15.0
				case 6:
					red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
					green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
					blue = CGFloat(hexValue & 0x0000FF) / 255.0
				case 8:
					red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
					green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
					blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
					alpha = CGFloat(hexValue & 0x000000FF) / 255.0
				default:
					log.warning("Invalid RGB string[\(rgba)], number of characters after '#' should be either 3, 4, 6 or 8")
				}
			} else {
				log.warning("Scan hex error")
			}
		} else {
			log.warning("Invalid RGB string[\(rgba)], missing '#' as prefix")
		}
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}

extension UIColor {
	convenience init(hex: Int) {
		let r: CGFloat = CGFloat(Double((hex & 0xFF0000) >> 16) / 255.0)
		let g: CGFloat = CGFloat(Double((hex & 0xFF00) >> 8) / 255.0)
		let b: CGFloat = CGFloat(Double(hex & 0xFF) / 255.0)
		self.init(red: r, green: g, blue: b, alpha: 1)
	}

	convenience init(ahex: Int64) {
		let a: CGFloat = CGFloat(Double((ahex & 0xFF000000) >> 24) / 255.0)
		let r: CGFloat = CGFloat(Double((ahex & 0xFF0000) >> 16) / 255.0)
		let g: CGFloat = CGFloat(Double((ahex & 0xFF00) >> 8) / 255.0)
		let b: CGFloat = CGFloat(Double(ahex & 0xFF) / 255.0)
		self.init(red: r, green: g, blue: b, alpha: a)
	}
    
    convenience init(hex: Int, alpha: CGFloat) {
        let r: CGFloat = CGFloat(Double((hex & 0xFF0000) >> 16) / 255.0)
        let g: CGFloat = CGFloat(Double((hex & 0xFF00) >> 8) / 255.0)
        let b: CGFloat = CGFloat(Double(hex & 0xFF) / 255.0)
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hexStr: String, alpha: CGFloat) {
        let scanner = Scanner(string: hexStr)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: CGFloat(r) / 0xff,
                  green: CGFloat(g) / 0xff,
                  blue: CGFloat(b) / 0xff,
                  alpha: alpha)
    }
}
