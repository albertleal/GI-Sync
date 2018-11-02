//
//  Photo.swift
//
//  Created by Wim Haanstra on 29/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import ObjectMapper

/// Metadata that is specific to a photo, such as, ISO, focal length and exposure time. Some of these fields
/// may be null or not included.
class Photo: Mappable {

    /// Brand of the camera with which the photo was taken.
    var cameraMake: String?

    /// Model of the camera with which the photo was taken.
    var cameraModel: String?

    /// Focal length of the camera lens with which the photo was taken.
    var focalLength: Float?

    /// ISO of the camera with which the photo was taken.
    var isoEquivalent: Int?

    /// Aperture f number of the camera lens with which the photo was taken.
    var aperatureFNumber: Int?

    /// Exposure time of the camera aperture when the photo was taken.
    var exposureTime: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        cameraMake <- map["cameraMake"]
        cameraModel <- map["cameraModel"]
        focalLength <- map["focalLength"]
        isoEquivalent <- map["isoEquivalent"]
        aperatureFNumber <- map["aperatureFNumber"]
        exposureTime <- map["exposureTime"]
    }
}
