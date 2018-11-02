//
//  MediaMetadata.swift
//
//  Created by Wim Haanstra on 29/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import ObjectMapper

/// Metadata for a media item.
class MediaMetadata: Mappable {

    /// Time when the media item was first created (not when it was uploaded to Google Photos).
    var creationTime: Date?

    /// Original height (in pixels) of the media item.
    var height: Int64?

    /// Original width (in pixels) of the media item.
    var width: Int64?

    /// Metadata for a photo media type.
    var photo: Photo?

    /// Metadata for a video media type.
    var video: Video?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        let dateFormatter = DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ", locale: "en_US_POSIX")
        creationTime <- (map["creationTime"], DateFormatterTransform(dateFormatter: dateFormatter))
        height <- (map["height"], StringToInt64Transform())
        width <- (map["width"], StringToInt64Transform())
        photo <- map["photo"]
        video <- map["video"]
    }
}
