//
//  ContentFilter.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import ObjectMapper

/// This filter allows you to return media items based on the content type.
class ContentFilter: Mappable {

    /// The set of categories to be included in the media item search results. The items in the set are ORed.
    /// There's a maximum of 10 includedContentCategories per request.
    var includedContentCategories: [ContentCategory]

    /// The set of categories which are not to be included in the media item search results. The items in
    /// the set are ORed. There's a maximum of 10 excludedContentCategories per request.
    var excludedContentCategories: [ContentCategory]

    init() {
        self.includedContentCategories = []
        self.excludedContentCategories = []
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        includedContentCategories <- (map["includedContentCategories"], ContentCategoriesTransform())
        excludedContentCategories <- (map["excludedContentCategories"], ContentCategoriesTransform())
    }
}
