//
//  DropTableStatement.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 20/05/2024.
//  Copyright © 2024 LUMBERCODE. All rights reserved.
//

import Foundation

class DropTableStatement {
    private var tableName: String
    init(with tableName: String) {
        self.tableName = tableName
    }
    func build() -> String? {
        var statement = "DROP TABLE IF EXISTS \(tableName);"
        return statement
    }
}
