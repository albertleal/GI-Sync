//
//  StringToInt64.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import ObjectMapper

/// TranformType for ObjectMapper, transforming an Int64 as String to Int64
class StringToInt64Transform: TransformType {
    public typealias Object = Int64
    public typealias JSON = String

    func transformFromJSON(_ value: Any?) -> Int64? {
        if let valueString = value as? String {
            return Int64(valueString)
        }
        return nil
    }

    func transformToJSON(_ value: Int64?) -> String? {
        if let intValue = value {
            return "\(intValue)"
        }
        return nil
    }
}
