//
//  Sundeed.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/10/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class Sundeed {
    static var shared: Sundeed = Sundeed()
    var tables: [String] = []
    final let backgroundQueue: DispatchQueue = DispatchQueue(
        label: "globalBackgroundSyncronizeSharedData")
    /// VALUE
    final let valueColumnName: String = "VALUE"
    /// <null>
    final let databaseNull: String = "<null>"
    /// SUNDEED_UNIQUE_KEY
    final let primaryKey: String = "SUNDEED_UNIQUE_KEY"
    /// SUNDEED_FOREIGN_KEY
    final let foreignKey: String = "SUNDEED_FOREIGN_KEY"
    /// SUNDEED_FIELD_NAME_LINK
    final let fieldNameLink: String = "SUNDEED_FIELD_NAME_LINK"
    /// SUNDEED_OFFLINE_ID
    final let offlineID: String = "SUNDEED_OFFLINE_ID"
    /// SUNDEED_FOREIGN|
    final let foreignPrefix: String = "SUNDEED_FOREIGN|"
    /// SUNDEED_PRIMITIVE_FOREIGN|
    final let foreignPrimitivePrefix: String = "SUNDEED_PRIMITIVE_FOREIGN|"
    /// SQLiteDB.sqlite
    final let databaseFileName: String = "SQLiteDB.sqlite"
    /// Empty string used in place of NULL for top-level objects' foreign key
    /// and field name link columns. SQLite treats NULLs as distinct in UNIQUE
    /// constraints, so REPLACE INTO never fires a conflict when these columns
    /// are NULL. Using a non-NULL sentinel ensures the composite UNIQUE
    /// constraint (foreignKey, primaryKey, fieldNameLink) works correctly for
    /// top-level objects, allowing REPLACE INTO to deduplicate as intended.
    final let topLevelSentinel: String = ""
    /// SUNDEED_FOREIGN|#tableName#|#foreignKey#
    final func sundeedForeignValue(tableName: Any,
                                   fieldNameLink: String,
                                   subObjectPrimaryKey: String? = nil) -> String {
        if let subObjectPrimaryKey = subObjectPrimaryKey {
            return "\(foreignPrefix)\(tableName)|\(fieldNameLink)|\(subObjectPrimaryKey)"
        } else {
            return "\(foreignPrefix)\(tableName)|\(fieldNameLink)"
        }
    }
    /// SUNDEED_PRIMITIVE_FOREIGN|#tableName#
    final func sundeedPrimitiveForeignValue(tableName: Any) -> String {
        return "\(foreignPrimitivePrefix)\(tableName)"
    }
}
