//
//  File.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import ObjectMapper

class File: Mappable {
    var kind: String?
    var id: String?
    var name: String?
    var mimeType: String?

    required init?(map: Map) {

    }

    // Mappable
    func mapping(map: Map) {
        kind <- map["kind"]
        id <- map["id"]
        name <- map["name"]
        mimeType <- map["mimeType"]
    }
}
