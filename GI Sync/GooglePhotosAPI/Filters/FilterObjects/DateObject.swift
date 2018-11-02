//
//  DateObject.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import ObjectMapper

/// Represents a whole calendar date. The day may be 0 to represent a year and month where the day isn't significant,
/// such as a whole calendar month. The month may be 0 to represent a a day and a year where the month isn't signficant,
/// like when you want to specify the same day in every month of a year or a specific year.
/// The year may be 0 to represent a month and day independent of year, like an anniversary date.
class DateObject: Mappable {
    /// Year of date. Must be from 1 to 9999, or 0 if specifying a date without a year.
    var year: Int

    /// Month of year. Must be from 1 to 12, or 0 if specifying a date without a month.
    var month: Int

    /// Day of month. Must be from 1 to 31 and valid for the year and month, or 0 if specifying a
    /// year/month where the day isn't significant.
    var day: Int

    init() {
        let calendar = Calendar.current
        let date = Date()

        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }

    convenience init(year: Int, month: Int, day: Int) {
        self.init()

        self.year = year
        self.month = month
        self.day = day
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        year <- map["year"]
        month <- map["month"]
        day <- map["day"]
    }

    func allMonth() -> DateObject {
        let result = DateObject(year: self.year, month: self.month, day: 0)
        return result
    }
}
