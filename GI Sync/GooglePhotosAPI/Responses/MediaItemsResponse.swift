//
//  MediaItems.swift
//
//  Created by Wim Haanstra on 29/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import Foundation
import ObjectMapper
import Alamofire

class MediaItemsResponse: Mappable {

    /// List of media items in the user's library.
    var mediaItems: [MediaItem] = []

    /// Token to use to get the next set of media items. Its presence is the only reliable
    /// indicator of more media items being available in the next request.
    var nextPageToken: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        mediaItems <- map["mediaItems"]
        nextPageToken <- map["nextPageToken"]
    }
}
