//
//  AlbumContentsResponse.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import ObjectMapper

class SearchResponse: Mappable {

    ///  List of media items that match the search parameters.
    var mediaItems: [MediaItem] = []

    ///  Use this token to get the next set of media items. Its presence is the only
    /// reliable indicator of more media items being available in the next request.
    var nextPageToken: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        mediaItems <- map["mediaItems"]
        nextPageToken <- map["nextPageToken"]
    }
}
