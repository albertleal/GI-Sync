//
//  ContributorInfo.swift
//
//  Created by Wim Haanstra on 30/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import ObjectMapper

/// Information about the user who added the media item. Note that this information is included only if the media
/// item is within a shared album created by your app and you have the sharing scope.
class ContributorInfo: Mappable {

    /// URL to the profile picture of the contributor.
    var profilePictureBaseUrl: String?

    /// Display name of the contributor.
    var displayName: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        profilePictureBaseUrl <- map["profilePictureBaseUrl"]
        displayName <- map["displayName"]
    }
}
