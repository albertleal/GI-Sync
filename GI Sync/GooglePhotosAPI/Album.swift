//
//  Album.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

/// Representation of an album in Google Photos. Albums are containers for media items.
/// If an album has been shared by the application, it contains an extra shareInfo property.
class Album: Mappable {

    /// Identifier for the album. This is a persistent identifier that can be used between
    /// sessions to identify this album.
    var id: String?

    /// Name of the album displayed to the user in their Google Photos account.
    /// This string shouldn't be more than 500 characters.
    var title: String?

    /// Google Photos URL for the album. The user needs to be signed in to their
    /// Google Photos account to access this link.
    var productUrl: String?

    /// A URL to the cover photo's bytes. This shouldn't be used as is. Parameters should be appended to this
    /// URL before use.For example, '=w2048-h1024' sets the dimensions of the cover photo to have a
    /// width of 2048 px and height of 1024 px.
    var coverPhotoBaseUrl: String?

    /// Identifier for the media item associated with the cover photo.
    var coverPhotoMediaItemId: String?

    ///  True if you can create media items in this album. This field is based on the scopes granted
    /// and permissions of the album. If the scopes are changed or permissions of the album are changed,
    /// this field is updated.
    var isWritable: Bool?

    /// Information related to shared albums. This field is only populated if the album is a shared album,
    /// the developer created the album and the user has granted the photoslibrary.sharing scope.
    var shareInfo: ShareInfo?

    ///  The number of media items in the album.
    var mediaItemsCount: Int?

    /* AlbumContents fields */
    var mediaItems: [MediaItem] = []

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        productUrl <- map["productUrl"]
        coverPhotoBaseUrl <- map["coverPhotoBaseUrl"]
        coverPhotoMediaItemId <- map["coverPhotoMediaItemId"]
        isWritable <- map["isWritable"]
        mediaItemsCount <- map["mediaItemsCount"]
    }

    /// Checks if a MediaItem is present in this album
    ///
    /// - Parameter item: The item to search for
    /// - Returns: Whether or not this item is present in the album
    func containsMediaItem(item: MediaItem) -> Bool {

        if item.id == nil {
            return false
        }

        return self.mediaItems.contains { element in
            return element.id == item.id
        }
    }

    /// Fetch MediaItem objects for this album
    ///
    /// - Parameters:
    ///   - pageToken: The token of the page to download, nil for the first page
    ///   - completed: The AlbumContentsResponse that Google Photos returned
    ///   - failed: When the request failed
    func getMediaItems(
        pageSize: Int = 20,
        pageToken: String?,
        completed: @escaping (_ response: SearchResponse) -> Void,
        failed: @escaping (_ error: Error) -> Void) {

        let url = "https://photoslibrary.googleapis.com/v1/mediaItems:search"

        if let albumId = self.id {
            var parameters: [String: Any] = ["albumId": albumId, "pageSize": pageSize]

            if let token = pageToken {
                parameters["pageToken"] = token
            }

            Alamofire.request(
                url,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: AuthenticationManager.shared().authorizationHeader()).responseObject { (response: DataResponse<SearchResponse>) in

                    if response.response?.statusCode == 200, let result = response.result.value {
                        self.appendMediaItems(items: result.mediaItems)
                        completed(result)
                    } else {
                        ErrorResponse.handleErrorResponse(response: response, failed: failed)
                    }
            }
        }
    }

    /// Shortcut method to downloading all the MediaItems for an album at once, will perform
    /// multiple queries when the user has a large photo collection.
    ///
    /// - Parameters:
    ///   - pageToken: The token of the page to download, nil for the first page
    ///   - mediaItems: Result set of MediaItem objects, which is carried over by recursive calls
    ///   - completed: The media items downloaded for the album
    ///   - failed: When the request failed
    func getAllMediaItems(
        pageToken: String? = nil,
        mediaItems: [MediaItem]? = nil,
        completed: @escaping (_ items: [MediaItem]) -> Void,
        failed: @escaping (_ error: Error) -> Void) {

        self.getMediaItems(pageToken: pageToken, completed: { (response) in

            var resultItems: [MediaItem] = []

            if let parameterMediaItems = mediaItems {
                resultItems.append(contentsOf: parameterMediaItems)
            }

            resultItems.append(contentsOf: response.mediaItems)

            if let token = response.nextPageToken {
                self.getAllMediaItems(pageToken: token, mediaItems: resultItems, completed: completed, failed: failed)
            } else {
                completed(resultItems)
            }

        }) { (error) in
            failed(error)
        }
    }

    /// Fetch albums from Google Photos
    ///
    /// - Parameters:
    ///   - pageSize: Maximum number of albums to return in the response. The default number of
    ///     albums to return at a time is 20. The maximum pageSize is 50.
    ///   - pageToken: The token of the page to download, nil for the first page
    ///   - completed: Response with albums and the nextPageToken
    ///   - failed: When the request fails, containing an Error
    static func list(
        pageSize: Int = 20,
        pageToken: String? = nil,
        completed: @escaping (_ response: AlbumsResponse) -> Void,
        failed: @escaping (_ error: Error) -> Void) {

        let url = "https://photoslibrary.googleapis.com/v1/albums"

        var parameters: [String: Any] = ["pageSize": pageSize]
        if let token = pageToken {
            parameters["pageToken"] = token
        }

        log.verbose("[GP] \(url)")

        Alamofire.request(
            url,
            method: .get,
            parameters: parameters,
            headers: AuthenticationManager.shared().authorizationHeader()).responseObject { (response: DataResponse<AlbumsResponse>) in

            if response.response?.statusCode == 200, let result = response.result.value {
                completed(result)
            } else {
                ErrorResponse.handleErrorResponse(response: response, failed: failed)
            }
        }
    }

    /// Shortcut method to downloading the metadata of all the photo albums
    ///
    /// - Parameters:
    ///   - pageToken: The pageToken to use, nil by default (for first page)
    ///   - albums: Result set of albums, which is carried over by recursive calls
    ///   - completed: Called when all albums are downloaded, supplies full list of albums
    static func listAll(
        pageToken: String? = nil,
        albums: [Album]? = nil,
        completed: @escaping (_ albums: [Album]) -> Void,
        failed: @escaping (_ error: Error) -> Void) {

        Album.list(pageToken: pageToken, completed: { (response) in
            var resultAlbums: [Album] = []

            if let parameterAlbums = albums {
                resultAlbums.append(contentsOf: parameterAlbums)
            }

            resultAlbums.append(contentsOf: response.albums)

            if let token = response.nextPageToken {
                self.listAll(pageToken: token, albums: resultAlbums, completed: completed, failed: failed)
            } else {
                completed(resultAlbums)
            }
        }) { (error) in
            failed(error)
        }
    }

    /// Returns the album based on the specified albumId. The albumId should be the ID of
    /// an album owned by the user or a shared album that the user has joined.
    ///
    /// - Parameters:
    ///   - albumId: Identifier of the album to be requested.
    ///   - completed: Album if found
    ///   - failed: Error when request fails or album isnt found
    static func get(
        albumId: String,
        completed: @escaping (_ response: Album) -> Void,
        failed: @escaping (_ error: Error) -> Void) {

        let url = "https://photoslibrary.googleapis.com/v1/albums/\(albumId)"
        log.verbose("[GP] \(url)")

        Alamofire.request(
            url,
            headers: AuthenticationManager.shared().authorizationHeader()).responseObject { (response: DataResponse<Album>) in

                if response.response?.statusCode == 200, let result = response.result.value {
                    completed(result)
                } else {
                    ErrorResponse.handleErrorResponse(response: response, failed: failed)
                }
        }
    }

    /// Appends MediaItem objects to this Album, skipped if it already exists
    ///
    /// - Parameter items: The items to add to this album
    private func appendMediaItems(items: [MediaItem]) {
        items.forEach({ (item) in
            if !self.containsMediaItem(item: item) {
                self.mediaItems.append(item)
            }
        })
    }
}
