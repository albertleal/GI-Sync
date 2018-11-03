//
//  MediaItem.swift
//
//  Created by Wim Haanstra on 29/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import ObjectMapper
import Alamofire

class MediaItem: Mappable {

    /// Identifier for the media item. This is a persistent identifier that can be used between sessions to identify
    /// this media item.
    var id: String?

    /// Description of the media item. This is shown to the user in the item's info section in the Google Photos app.
    var description: String?

    /// A URL to the media item's bytes. This shouldn't be used directly to access the media item.
    /// For example, '=w2048-h1024' will set the dimensions of a media item of type photo to have a width of 2048 px
    /// and height of 1024 px.
    var baseUrl: String?

    /// Filename of the media item. This is shown to the user in the item's info section in the Google Photos app.
    var filename: String?

    /// MIME type of the media item. For example, image/jpeg.
    var mimeType: String?

    /// Google Photos URL for the media item. This link is available to the user only if they're signed in.
    var productUrl: String?

    /// Metadata related to the media item, such as, height, width, or creation time.
    var mediaMetadata: MediaMetadata?

    /// Information about the user who created this media item.
    var contributorInfo: ContributorInfo?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        baseUrl <- map["baseUrl"]
        filename <- map["filename"]
        mimeType <- map["mimeType"]
        productUrl <- map["productUrl"]
        mediaMetadata <- map["mediaMetadata"]
        contributorInfo <- map["contributorInfo"]
    }

    /// Download image for this MediaItem
    ///
    /// - Parameters:
    ///   - completed: An image if found in Google Photos
    ///   - failed: When the request fails, containing an Error
    func download(completed: @escaping (_ image: NSImage) -> Void, failed: @escaping (_ error: Error) -> Void) {
        if let url = self.baseUrl,
            let metaData = self.mediaMetadata,
            let width = metaData.width,
            let height = metaData.height {

            let fullSizeUrl = "\(url)=w\(width)-h\(height)-d"
            log.verbose("[GP] \(fullSizeUrl)")

            Alamofire.request(
                fullSizeUrl,
                headers: AuthenticationHelper.shared().authorizationHeader()).responseData { (response: DataResponse<Data>) in

                if response.response?.statusCode == 200, let result = response.result.value, let image = NSImage(data: result) {
                    completed(image)
                } else {
                    ErrorResponse.handleErrorResponse(response: response, failed: failed)
                }
            }

        } else {
            let error = NSError(domain: "", code: 900, userInfo: nil)
            failed(error as Error)
        }
    }

    /// Download media items without filter
    ///
    /// - Parameters:
    ///   - pageToken: The token of the page to download, nil for the first page
    ///   - completed: Response with media items and the nextPageToken
    ///   - failed: When the request fails, containing an Error
    static func list(
        pageSize: Int = 100,
        pageToken: String? = nil,
        completed: @escaping (_ response: MediaItemsResponse) -> Void,
        failed: @escaping (_ error: Error) -> Void) {

        let url = "https://photoslibrary.googleapis.com/v1/mediaItems"

        var parameters: [String: Any] = ["pageSize": pageSize]
        if let token = pageToken {
            parameters["pageToken"] = token
        }

        log.verbose("[GP] \(url)")

        Alamofire.request(
            url,
            method: .get,
            parameters: parameters,
            headers: AuthenticationHelper.shared().authorizationHeader()).responseObject { (response: DataResponse<MediaItemsResponse>) in

            if response.response?.statusCode == 200, let result = response.result.value {
                completed(result)
            } else {
                ErrorResponse.handleErrorResponse(response: response, failed: failed)
            }
        }
    }

    /// Shortcut method to downloading all the MediaItems at once, will perform
    /// multiple queries when the user has a large photo collection.
    ///
    /// - Parameters:
    ///   - pageToken: The token of the page to download, nil for the first page
    ///   - mediaItems: Result set of MediaItem objects, which is carried over by recursive calls
    ///   - completed: Called when all MediaItem objects are downloaded, supplies full list of MediaItem objects
    ///   - failed: Called when the request fails, containing error information
    static func listAll(
        pageToken: String? = nil,
        mediaItems: [MediaItem]? = nil,
        completed: @escaping (_ mediaItems: [MediaItem]) -> Void,
        failed: @escaping (_ error: Error) -> Void) {

        MediaItem.list(completed: { (response) in

            var resultItems: [MediaItem] = []

            if let parameterMediaItems = mediaItems {
                resultItems.append(contentsOf: parameterMediaItems)
            }

            resultItems.append(contentsOf: response.mediaItems)

            if let token = response.nextPageToken {
                self.listAll(pageToken: token, mediaItems: resultItems, completed: completed, failed: failed)
            } else {
                completed(resultItems)
            }

        }) { (error) in
            failed(error)
        }

    }

    /// Returns the media item for the specified media item id.
    ///
    /// - Parameters:
    ///   - mediaItemId: Identifier of media item to be requested.
    ///   - completed: MediaItem if it is found
    ///   - failed: When the request fails, or the item is not found
    static func get(
        mediaItemId: String,
        completed: @escaping (_ response: MediaItem) -> Void,
        failed: @escaping (_ error: Error) -> Void) {

        let url = "https://photoslibrary.googleapis.com/v1/mediaItems/\(mediaItemId)"
        log.verbose("[GP] \(url)")

        Alamofire.request(
            url,
            headers: AuthenticationHelper.shared().authorizationHeader()).responseObject { (response: DataResponse<MediaItem>) in
            if response.response?.statusCode == 200, let result = response.result.value {
                completed(result)
            } else {
                ErrorResponse.handleErrorResponse(response: response, failed: failed)
            }
        }
    }

    /// Search through the MediaItems
    ///
    /// - Parameters:
    ///   - filters: Filters that need to be applied to the search
    ///   - pageSize: The pagesize for the results returned
    ///   - pageToken: The token of the page to download, nil for the first page
    ///   - completed: Called when all MediaItem objects are downloaded, supplies full list of MediaItem objects
    ///   - failed: Called when the request fails, containing error information
    static func search(
        filters: Filters,
        pageSize: Int = 25,
        pageToken: String? = nil,
        completed: @escaping (_ response: SearchResponse) -> Void,
        failed: @escaping (_ error: Error) -> Void) {

        let url = "https://photoslibrary.googleapis.com/v1/mediaItems:search?alt=json"

        var parameters: [String: Any] = ["pageSize": pageSize]
        parameters["filters"] = filters.toJSON()

        if let token = pageToken {
            parameters["pageToken"] = token
        }

        Alamofire.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: AuthenticationHelper.shared().authorizationHeader()).responseObject { (response: DataResponse<SearchResponse>) in
                if response.response?.statusCode == 200, let searchResponse = response.result.value {
                    completed(searchResponse)
                } else {
                    ErrorResponse.handleErrorResponse(response: response, failed: failed)
                }
        }
    }
}
