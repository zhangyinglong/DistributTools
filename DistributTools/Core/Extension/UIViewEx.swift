//
//  UIViewEx.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/10.
//  Copyright © 2016年 zhang yinglong. All rights reserved.
//

import UIKit

extension UIView {
    
    var top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame = CGRect(x: left, y: newValue, width: width, height: height)
        }
    }

    var left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame = CGRect(x: newValue, y: top, width: width, height: height)
        }
    }

    var bottom: CGFloat {
        get {
            return frame.origin.y + height
        }
        set {
            let offset_y: CGFloat = newValue - top - height
            frame = CGRect(x: left, y: top + offset_y, width: width, height: height)
        }
    }

    var right: CGFloat {
        get {
            return frame.origin.x + width
        }
        set {
            let offset_x: CGFloat = newValue - left - width
            frame = CGRect(x: left + offset_x, y: top, width: width, height: height)
        }
    }

    var width: CGFloat {
        get {
            return frame.width
        }
        set {
            frame = CGRect(x: left, y: top, width: newValue, height: height)
        }
    }

    var height: CGFloat {
        get {
            return frame.height
        }
        set {
            frame = CGRect(x: left, y: top, width: width, height: newValue)
        }
    }

    var midX: CGFloat {
        get {
            return center.x
        }
        set {
            center = CGPoint(x: newValue, y: center.y)
        }
    }

    var midY: CGFloat {
        get {
            return center.y
        }
        set {
            center = CGPoint(x: center.x, y: newValue)
        }
    }

}
