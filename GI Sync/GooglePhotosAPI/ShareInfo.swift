//
//  ShareInfo.swift
//
//  Created by Wim Haanstra on 01/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import ObjectMapper

class ShareInfo: Mappable {

    /// A link to the album that's now shared on the Google Photos website and app.
    /// Anyone with the link can access this shared album and see all of the items present in the album.
    var shareableUrl: String?

    /// A token that can be used by other users to join this shared album via the API.
    var shareToken: String?

    /// True if the user has joined the album. This is always true for the owner of the shared album.
    var isJoined: Bool?

    /// Options that control the sharing of an album.
    var sharedAlbumOptions: SharedAlbumOptions?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        shareableUrl <- map["shareableUrl"]
        shareToken <- map["shareToken"]
        isJoined <- map["isJoined"]
        sharedAlbumOptions <- map["sharedAlbumOptions"]
    }
}
