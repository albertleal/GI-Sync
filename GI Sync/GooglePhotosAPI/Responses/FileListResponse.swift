//
//  FileListResponse.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import ObjectMapper

class FileListResponse: Mappable {
    var kind: String?
    var incompleteSearch: Bool?
    var nextPageToken: String?
    var files: [File]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        kind <- map["kind"]
        incompleteSearch <- map["incompleteSearch"]
        nextPageToken <- map["nextPageToken"]
        files <- map["files"]
    }
}
