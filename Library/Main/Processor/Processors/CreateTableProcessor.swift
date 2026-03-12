//
//  SundeedCreateTableProcessor.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 5/11/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import Foundation

class CreateTableProcessor: Processor {
    func createTableIfNeeded(for object: ObjectWrapper?) throws {
        guard let object = object,
              let objects = object.objects else {
            throw SundeedQLiteError.noObjectPassed
        }
        if !Sundeed.shared.tables.contains(object.tableName) {
            SundeedLogger.info("Creating table for \(object.tableName)")
            let createTableStatement = StatementBuilder()
                .createTableStatement(tableName: object.tableName)
            for (columnName, attribute) in objects {
                if let attribute = attribute as? ObjectWrapper {
                    try createTableIfNeeded(for: attribute)
                } else if let attribute = attribute as? [ObjectWrapper] {
                    if let firstAttribute = attribute.first {
                        try createTableIfNeeded(for: firstAttribute)
                    }
                } else if attribute is [Any] {
                    if let array = attribute as? [Any], let _ = array.first as? Data {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .blob(nil))
                    } else if let array = attribute as? [Any], let _ = array.first as? Date {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .double(nil))
                    } else if let array = attribute as? [Any], let attribute = array.first as? NSNumber, !CFNumberIsFloatType(attribute as CFNumber) {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .integer(nil))
                    } else if let array = attribute as? [Any], let _ = array.first as? Double {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .double(nil))
                    } else if let array = attribute as? [Any], let _ = array.first as? Float {
                        createTableForPrimitiveDataTypes(withTableName: columnName, type: .double(nil))
                    } else {
                        createTableForPrimitiveDataTypes(withTableName: columnName)
                    }
                }
                let concreteType = object.types?[columnName]
                if attribute is Array<AnyObject> {
                    createTableStatement.addColumn(with: columnName, type: .text(nil))
                } else {
                    switch concreteType {
                    case .blob:
                        createTableStatement.addColumn(with: columnName, type: .blob(nil))
                    case .double:
                        createTableStatement.addColumn(with: columnName, type: .double(nil))
                    case .integer:
                        createTableStatement.addColumn(with: columnName, type: .integer(nil))
                    default:
                        createTableStatement.addColumn(with: columnName, type: .text(nil))
                    }
                }
                if columnName == "index" {
                    throw SundeedQLiteError.cantUseNameIndex(tableName: object.tableName)
                }
            }
            let hasPrimaryKey = objects[Sundeed.shared.primaryKey] != nil
            if hasPrimaryKey {
                createTableStatement.withPrimaryKey()
            }
            let statement: String? = createTableStatement.build()
            SundeedQLiteConnection.pool.execute(query: statement,
                                                parameters: nil)
            // Only migrate tables with a primary key — they're the ones with
            // the UNIQUE constraint where the NULL-uniqueness bug manifests.
            if hasPrimaryKey {
                migrateNullSentinels(tableName: object.tableName)
            }
            Sundeed.shared.tables.append(object.tableName)
        }
    }
    /// Migrates pre-existing rows that used NULL for top-level objects'
    /// `SUNDEED_FOREIGN_KEY` and `SUNDEED_FIELD_NAME_LINK` columns to the
    /// non-NULL sentinel value. This is necessary because SQLite treats NULLs
    /// as distinct in UNIQUE constraints, which caused `REPLACE INTO` to
    /// accumulate duplicate rows for top-level objects.
    ///
    /// The migration:
    /// 1. Removes duplicate top-level rows, keeping only the most recent
    ///    (highest `SUNDEED_OFFLINE_ID`) per primary key.
    /// 2. Converts remaining NULL values to the sentinel so the UNIQUE
    ///    constraint works correctly going forward.
    ///
    /// This is idempotent — once NULLs are converted, subsequent runs are
    /// no-ops because the WHERE clauses no longer match any rows.
    ///
    /// - TODO: Remove this migration after a sufficient number of major
    ///   versions have passed (e.g. 2 major releases) so that all
    ///   consumers have had a chance to run it at least once.
    private func migrateNullSentinels(tableName: String) {
        let offlineID = Sundeed.shared.offlineID
        let foreignKey = Sundeed.shared.foreignKey
        let primaryKey = Sundeed.shared.primaryKey
        let fieldNameLink = Sundeed.shared.fieldNameLink
        let sentinel = Sundeed.shared.topLevelSentinel
        // Step 1: Remove duplicate top-level rows, keeping only the latest
        // per primary key. This cleans up databases where the NULL-uniqueness
        // bug caused duplicate accumulation.
        let dedup = """
            DELETE FROM \(tableName)
            WHERE \(foreignKey) IS NULL
              AND \(offlineID) NOT IN (
                SELECT MAX(\(offlineID))
                FROM \(tableName)
                WHERE \(foreignKey) IS NULL
                GROUP BY \(primaryKey)
              );
            """
        SundeedQLiteConnection.pool.execute(query: dedup, parameters: nil)
        // Step 2: Convert remaining NULLs to the sentinel value so the
        // UNIQUE constraint can enforce deduplication going forward.
        let migrateForeignKey = """
            UPDATE \(tableName)
            SET \(foreignKey) = '\(sentinel)'
            WHERE \(foreignKey) IS NULL;
            """
        SundeedQLiteConnection.pool.execute(query: migrateForeignKey, parameters: nil)
        let migrateFieldNameLink = """
            UPDATE \(tableName)
            SET \(fieldNameLink) = '\(sentinel)'
            WHERE \(fieldNameLink) IS NULL;
            """
        SundeedQLiteConnection.pool.execute(query: migrateFieldNameLink, parameters: nil)
    }
    /** Try to create table for primitive data types if not already exists */
    func createTableForPrimitiveDataTypes(withTableName tableName: String,
                                          type: ParameterType = .text(nil)) {
        if  !Sundeed.shared.tables.contains(tableName) {
            let createTableStatement = StatementBuilder()
                .createTableStatement(tableName: tableName)
                .addColumn(with: Sundeed.shared.valueColumnName, type: type)
                .build()
            SundeedQLiteConnection.pool.execute(query: createTableStatement, parameters: nil)
            Sundeed.shared.tables.append(tableName)
        }
    }
}
