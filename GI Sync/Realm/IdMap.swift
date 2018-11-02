//
//  IdMap.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import RealmSwift

/// Object storing the mapping between Google Photos and iCloud
class IdMap: Object {

    /// localIdentifier from PHAsset
    @objc dynamic var icloudIdentifier: String = ""

    /// Identifier from Google Photos
    @objc dynamic var googleIdentifier: String = ""

    /// Date when the mapping is made
    @objc dynamic var date: Date = Date()

    func toString() -> String {
        return ">>> \(self.googleIdentifier) -> \(self.icloudIdentifier)"
    }
}
