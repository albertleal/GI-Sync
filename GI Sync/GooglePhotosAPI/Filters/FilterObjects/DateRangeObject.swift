//
//  DateRangeObject.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import ObjectMapper

/// Defines a range of dates. Both dates must be of the same format. For more information, see DateObject
class DateRangeObject: Mappable {
    /// The start date (included as part of the range) in one of the formats described.
    var startDate: DateObject

    /// The end date (included as part of the range). It must be specified in the same format as the start date.
    var endDate: DateObject

    init() {
        self.startDate =  Date().toDateObject()
        self.endDate = Date().toDateObject()
    }

    convenience init(startDate: DateObject, endDate: DateObject) {
        self.init()

        self.startDate = startDate
        self.endDate = endDate
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        startDate <- map["startDate"]
        endDate <- map["endDate"]
    }
}
