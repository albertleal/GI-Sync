//
//  Filters.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import ObjectMapper

class Filters: Mappable {

    /// Filters the media items based on their creation date.
    var dateFilter: DateFilter

    /// Filters the media items based on their content.
    var contentFilter: ContentFilter

    /// Filters the media items based on the type of media.
    var mediaTypeFilter: MediaTypeFilter

    /// If set, the results include media items that the user has archived.
    /// Defaults to false (archived media items aren't included).
    var includeArchivedMedia: Bool?

    /// If set, the results exclude media items that were not created by this app.
    /// Defaults to false (all media items are returned). This field is ignored if the
    /// photoslibrary.readonly.appcreateddata scope is used.
    var excludeNonAppCreatedData: Bool?

    init() {
        self.dateFilter = DateFilter()
        self.contentFilter = ContentFilter()
        self.mediaTypeFilter = MediaTypeFilter()
    }

    required init?(map: Map) {
        self.dateFilter = DateFilter()
        self.contentFilter = ContentFilter()
        self.mediaTypeFilter = MediaTypeFilter()
    }

    func mapping(map: Map) {
        dateFilter <- map["dateFilter"]
        contentFilter <- map["contentFilter"]
        mediaTypeFilter <- map["mediaTypeFilter"]

        includeArchivedMedia <- map["includeArchivedMedia"]
        excludeNonAppCreatedData <- map["excludeNonAppCreatedData"]
    }

    /// Add a DateObject to this filter
    ///
    /// - Parameter date: DateObject for the filter
    func addDate(date: DateObject) {
        self.dateFilter.dates.append(date)
    }

    /// Add a DateRangeObject to this filter
    ///
    /// - Parameters:
    ///   - startDate: Start date for the range filter
    ///   - endDate: End date for the range filter
    func addRange(startDate: DateObject, endDate: DateObject) {
        let range = DateRangeObject(startDate: startDate, endDate: endDate)
        self.dateFilter.ranges.append(range)
    }

    func addContentCategory(category: ContentCategory) {
        self.contentFilter.includedContentCategories.append(category)
    }

    /// Create a filter with the supplied date
    ///
    /// - Parameter date: The date to filter on
    /// - Returns: A filter containing the date
    static func create(date: DateObject) -> Filters {
        let filter = Filters()
        filter.addDate(date: date)
        return filter
    }

    /// Create a filter with the supplied date range
    ///
    /// - Parameters:
    ///   - startDate: Start date for the range filter
    ///   - endDate: End date for the range filter
    /// - Returns: A filter containing the date range
    static func create(startDate: DateObject, endDate: DateObject) -> Filters {
        let filter = Filters()
        filter.addRange(startDate: startDate, endDate: endDate)
        return filter
    }

    static func create(category: ContentCategory) -> Filters {
        let filter = Filters()
        filter.addContentCategory(category: category)
        return filter

    }
}
