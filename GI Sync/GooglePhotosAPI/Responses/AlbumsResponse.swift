//
//  AlbumsResponse.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import ObjectMapper

/// Response for Lists all albums shown to a user in the Albums tab of the Google Photos app.
class AlbumsResponse: Mappable {

    /// List of albums shown in the Albums tab of the user's Google Photos app.
    var albums: [Album] = []

    /// Token to use to get the next set of albums. Populated if there are more albums to retrieve for this request.
    var nextPageToken: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        albums <- map["albums"]
        nextPageToken <- map["nextPageToken"]
    }
}
