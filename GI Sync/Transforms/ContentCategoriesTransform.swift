//
//  StringToInt64.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import ObjectMapper

/// TranformType for ObjectMapper, transforming an Int64 as String to Int64
class ContentCategoriesTransform: TransformType {
    public typealias Object = [ContentCategory]
    public typealias JSON = [String]

    func transformFromJSON(_ value: Any?) -> [ContentCategory]? {
        var result: [ContentCategory] = []

        if let strings = value as? [String] {
            strings.forEach { (categoryValue) in
                if let category = ContentCategory.init(rawValue: categoryValue) {
                    result.append(category)
                }
            }
        }

        return result
    }

    func transformToJSON(_ value: [ContentCategory]?) -> [String]? {
        var result: [String] = []

        if let categories = value {
            categories.forEach { (category) in
                result.append(category.rawValue)
            }
        }
        if result.count == 0 {
            return nil
        }
        return result
    }
}
