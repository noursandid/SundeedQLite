//
//  StatementBuilderTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class StatementBuilderTests: XCTestCase {
    let builder = StatementBuilder()

    func testCreateTableStatement() {
        let statement = builder.createTableStatement(tableName: "TestTable")
        XCTAssertTrue(statement is CreateTableStatement)
    }

    func testDeleteStatement() {
        let statement = builder.deleteStatement(tableName: "TestTable")
        XCTAssertTrue(statement is DeleteStatement)
    }

    func testInsertStatement() {
        let statement = builder.insertStatement(tableName: "TestTable")
        XCTAssertTrue(statement is InsertStatement)
    }

    func testUpdateStatement() {
        let statement = builder.updateStatement(tableName: "TestTable")
        XCTAssertTrue(statement is UpdateStatement)
    }

    func testSelectStatement() {
        let statement = builder.selectStatement(tableName: "TestTable")
        XCTAssertTrue(statement is SelectStatement)
    }
}
