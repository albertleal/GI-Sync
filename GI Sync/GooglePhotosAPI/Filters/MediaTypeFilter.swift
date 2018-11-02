//
//  MediaTypeFilter.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import ObjectMapper

/// This filter defines the type of media items to be returned, for example, videos or photos.
/// All the specified media types are treated as an OR when used together.
class MediaTypeFilter: Mappable {
    /// The types of media items to be included. This field should be populated with only one media type.
    /// If you specify multiple media types, it results in an error.
    var mediaTypes: [MediaType]

    init() {
        self.mediaTypes = []
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        mediaTypes <- (map["mediaTypes"], EnumTransform<MediaType>())
    }
}
