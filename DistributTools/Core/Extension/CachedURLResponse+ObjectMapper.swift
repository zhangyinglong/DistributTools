//
//  CachedURLResponse+ObjectMapper.swift
//  DistributTools
//
//  Created by zhang yinglong on 2017/5/27.
//  Copyright © 2017年 ChinaHR. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper

extension CachedURLResponse {
    
    /// Maps data received from the signal into a JSON object.
    public func mapJSON(failsOnEmptyData: Bool = true) throws -> Any {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            if data.count < 1 && !failsOnEmptyData {
                return NSNull()
            }
            throw DistributToolsError.error(code: 1000, reason: "error json map")
        }
    }

    public func ObjectMapperSerializer<T: Mappable>() -> T? {
        do {
            let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return Mapper<T>().map(JSONObject: JSON)
        } catch {
            return nil
        }
    }
    
    public func ObjectMapperArraySerializer<T: Mappable>() -> [T] {
        do {
            let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return Mapper<T>().mapArray(JSONObject: JSON)!
        } catch {
            return []
        }
    }
    
}

extension Response {
    
    public func ObjectMapperSerializer<T: Mappable>() -> T? {
        do {
            let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return Mapper<T>().map(JSONObject: JSON)
        } catch {
            return nil
        }
    }
    
    public func ObjectMapperArraySerializer<T: Mappable>() -> [T] {
        do {
            let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return Mapper<T>().mapArray(JSONObject: JSON)!
        } catch {
            return []
        }
    }
    
}
