//
//  Results.swift
//
//  Created by Wim Haanstra on 01/11/2018.
//  Copyright © 2018 Wim Haanstra. All rights reserved.
//
import RealmSwift

extension Results {
    /// Convert Realm Results to a typed array
    ///
    /// - Parameter ofType: The type of the objects in the Results object
    /// - Returns: An array of T objects
    func toArray<T>(ofType: T.Type) -> [T] {
        return Array(self) as! [T]
    }
}
