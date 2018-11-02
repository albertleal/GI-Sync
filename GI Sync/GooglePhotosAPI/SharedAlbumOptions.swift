//
//  SharedAlbumOptions.swift
//
//  Created by Wim Haanstra on 01/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import ObjectMapper

/// Options that control the sharing of an album.
class SharedAlbumOptions: Mappable {
    /// True if the shared album allows collaborators (users who have joined the album) to add media items to it.
    /// Defaults to false.
    var isCollaborative: Bool?

    /// True if the shared album allows the owner and the collaborators (users who have joined the album)
    /// to add comments to the album. Defaults to false.
    var isCommentable: Bool?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        isCollaborative <- map["isCollaborative"]
        isCommentable <- map["isCommentable"]
    }
}
