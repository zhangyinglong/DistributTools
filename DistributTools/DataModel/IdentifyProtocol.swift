//
//  IdentifyProtocol.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/3/7.
//  Copyright © 2017年 ChinaHR. All rights reserved.
//

import ObjectMapper

protocol IdentifyProtocol: Equatable, CustomStringConvertible {
    
    var id: String { get set }

}

extension IdentifyProtocol {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}
