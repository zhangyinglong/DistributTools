//
//  StringEx.swift
//  DistributTools
//
//  Created by zhangyinglong on 16/1/18.
//  Copyright © 2016年 zhang yinglong. All rights reserved.
//

import UIKit

extension String {

    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex
            let endIndex = self.startIndex

            return self[Range(startIndex ..< endIndex)]
        }
    }

    func boundingRectWithSize(size: CGSize, options: NSStringDrawingOptions, attributes: [String: NSObject], context: NSStringDrawingContext) -> CGRect {
        return (self as NSString).boundingRect(with: size, options:options, attributes: attributes, context: context)
    }

}
