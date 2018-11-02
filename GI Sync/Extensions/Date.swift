//
//  Date.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation

extension Date {
    /// Converts a Date to a DateObject for a Filter
    ///
    /// - Returns: DateObject filter
    func toDateObject() -> DateObject {
        let calendar = Calendar.current

        let result = DateObject()
        result.year = calendar.component(.year, from: self)
        result.month = calendar.component(.month, from: self)
        result.day = calendar.component(.day, from: self)
        return result
    }

    /// Converts two dates to a DateRangeObject for a filter
    ///
    /// - Parameter to: End date of the range
    /// - Returns: DateRangeObject filter
    func toRangeObject(endDate: Date) -> DateRangeObject {
        return DateRangeObject(startDate: self.toDateObject(), endDate: endDate.toDateObject())
    }
}
