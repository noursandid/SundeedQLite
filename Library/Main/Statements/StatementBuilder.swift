//
//  SundeedStatements.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/9/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class StatementBuilder {
    func createTableStatement(tableName: String) -> CreateTableStatement {
        return CreateTableStatement(with: tableName)
    }
    func deleteStatement(tableName: String) -> DeleteStatement {
        return DeleteStatement(with: tableName)
    }
    func insertStatement(tableName: String) -> InsertStatement {
        return InsertStatement(with: tableName)
    }
    func updateStatement(tableName: String) -> UpdateStatement {
        return UpdateStatement(with: tableName)
    }
    func selectStatement(tableName: String) -> SelectStatement {
        return SelectStatement(with: tableName)
    }
}
