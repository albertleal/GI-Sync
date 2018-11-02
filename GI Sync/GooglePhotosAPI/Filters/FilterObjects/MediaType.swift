//
//  MediaType.swift
//  ImportPhotos
//
//  Created by Wim Haanstra on 02/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation

/// The set of media types that can be searched for.
///
/// - all: Treated as if no filters are applied. All media types are included.
/// - video: All media items that are considered videos. This also includes movies the user has created using the Google Photos app.
/// - photo: All media items that are considered photos. This includes .bmp, .gif, .ico, .jpg (and other spellings), .tiff,
///          .webp and special photo types such as iOS live photos, Android motion photos, panoramas, photospheres.
enum MediaType: String {
    case all = "ALL_MEDIA"
    case video = "VIDEO"
    case photo = "PHOTO"
}
