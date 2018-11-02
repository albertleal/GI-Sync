//
//  DataManager.swift
//
//  Created by Wim Haanstra on 31/10/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//

import Foundation
import RealmSwift

/// Temporary singleton for managing Realm data
class DataManager {
    private static var sharedDataManager: DataManager = {
        let manager = DataManager()
        return manager
    }()

    var realm: Realm

    private init() {
        self.realm = try! Realm()
    }

    class func shared() -> DataManager {
        return self.sharedDataManager
    }

    /// Gets all IdMap objects from Realm database
    ///
    /// - Returns: All IdMap objects in the database
    func idMaps() -> [IdMap] {
        let result = self.realm.objects(IdMap.self)
        return result.toArray(ofType: IdMap.self)
    }

    /// Gets an IdMap object with the supplied PHAsset localIdentifier
    ///
    /// - Parameter icloudIdentifier: The PHAsset localIdentifier to search for
    /// - Returns: The Mapping object
    func idMap(icloudIdentifier: String) -> IdMap? {
        let result = self.realm.objects(IdMap.self).filter("icloudIdentifier = %@", icloudIdentifier)
        if result.count == 0 {
            return nil
        } else {
            return result.first!
        }
    }

    /// Gets an IdMap object with the supplied Google Photos identifier
    ///
    /// - Parameter googleIdentifier: The Google Photos identifier to search for
    /// - Returns: The Mapping object
    func idMap(googleIdentifier: String) -> IdMap? {
        let result = self.realm.objects(IdMap.self).filter("googleIdentifier = %@", googleIdentifier)
        if result.count == 0 {
            return nil
        } else {
            return result.first!
        }
    }

    /// Add a new mapping to the database
    ///
    /// - Parameters:
    ///   - icloudIdentifier: PHAsset localIdentifier
    ///   - googleIdentifier: Google Photos identifier
    /// - Returns: The newly created mapping
    func addIdMap(icloudIdentifier: String, googleIdentifier: String) -> IdMap {
        let map = IdMap()
        map.googleIdentifier = googleIdentifier
        map.icloudIdentifier = icloudIdentifier
        map.date = Date()

        try! self.realm.write {
            self.realm.add(map)
        }
        return map
    }
}
