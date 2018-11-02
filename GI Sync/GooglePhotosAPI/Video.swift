//
//  Video.swift
//
//  Created by Wim Haanstra on 29/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import ObjectMapper

/// Metadata that is specific to a video, for example, fps and processing status.
/// Some of these fields may be null or not included.
class Video: Mappable {

    /// Brand of the camera with which the photo was taken.
    var cameraMake: String?

    /// Model of the camera with which the photo was taken.
    var cameraModel: String?

    var fps: Float?

    var status: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        cameraMake <- map["cameraMake"]
        cameraModel <- map["cameraModel"]
        fps <- map["fps"]
        status <- map["status"]
    }
}
