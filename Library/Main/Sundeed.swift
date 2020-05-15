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

    final lazy var dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter
    }()
    var tables:[String] = []
    
    final let backgroundQueue: DispatchQueue = DispatchQueue(
        label: "globalBackgroundSyncronizeSharedData")
    
    /// SUNDEED_UNIQUE_KEY
    final let primaryKey: String = "SUNDEED_UNIQUE_KEY"
    
    /// SUNDEED_FOREIGN_KEY
    final let foreignKey: String = "SUNDEED_FOREIGN_KEY"
    
    /// SUNDEED_FOREIGN|
    final let foreignPrefix: String = "SUNDEED_FOREIGN|"
    
    /// SUNDEED_PRIMITIVE_FOREIGN|
    final let foreignPrimitivePrefix: String = "SUNDEED_PRIMITIVE_FOREIGN|"
    
    /// SQLiteDB.sqlite
    final let databaseFileName: String = "SQLiteDB.sqlite"
    
    /// shouldCopyDatabaseToFilePath
    final let shouldCopyDatabaseToFilePathKey: String = "shouldCopyDatabaseToFilePath"
    
    /// SUNDEED_FOREIGN|#tableName#|#foreignKey#
    final func sundeedForeignValue(tableName: Any, foreignKey: String? = nil) -> String {
        if let foreignKey = foreignKey {
            return "\(foreignPrefix)\(tableName)|\(foreignKey)"
        } else {
            return "\(foreignPrefix)\(tableName)"
        }
    }
    
    /// SUNDEED_PRIMITIVE_FOREIGN|#tableName#
    final func sundeedPrimitiveForeignValue(tableName: Any) -> String {
        return "\(foreignPrimitivePrefix)\(tableName)"
    }
}
