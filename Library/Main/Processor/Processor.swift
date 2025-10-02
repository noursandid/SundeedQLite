//
//  Processor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 01/10/2025.
//  Copyright © 2025 LUMBERCODE. All rights reserved.
//

import Foundation
import SQLite3

class Processor {
    func getDatabaseColumns(forTable table: String) -> [(columnName: String, columnType: ParameterType)] {
        let database = SundeedQLiteConnection.pool.connection()
        var columnsStatement: OpaquePointer?
        var array: [(columnName: String, columnType: ParameterType)] = []
        sqlite3_prepare_v2(database,
                           "PRAGMA table_info(\(table));",-1,
                           &columnsStatement, nil)
        while sqlite3_step(columnsStatement) == SQLITE_ROW {
            if let columnName = sqlite3_column_text(columnsStatement, 1),
               let columnType = sqlite3_column_text(columnsStatement, 2) {
                array.append((columnName: String(cString: columnName),
                              columnType: ParameterType(typeString: String(cString: columnType))))
            }
        }
        columnsStatement = nil
        SundeedQLiteConnection.pool.closeConnection(database)
        return array
    }
}
