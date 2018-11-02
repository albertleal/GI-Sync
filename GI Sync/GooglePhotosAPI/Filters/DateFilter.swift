//
//  DateFilter.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import ObjectMapper

/// Filters the media items based on their creation date.
class DateFilter: Mappable {

    /// List of dates that match the media items' creation date. A maximum of 5 dates can be included per request.
    var dates: [DateObject]

    /// List of dates ranges that match the media items' creation date.
    /// A maximum of 5 dates ranges can be included per request.
    var ranges: [DateRangeObject]

    init() {
        self.dates = []
        self.ranges = []
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        dates <- map["dates"]
        ranges <- map["ranges"]
    }
}
