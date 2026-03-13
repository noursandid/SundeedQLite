//
//  CreateTableStatementTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class CreateTableStatementTests: XCTestCase {
    func testCreateTableStatementBasic() {
        let statement = CreateTableStatement(with: "TestTable")
            .addColumn(with: "name", type: .text(""))
            .addColumn(with: "age", type: .integer(0))
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.contains("CREATE TABLE IF NOT EXISTS TestTable") == true)
        XCTAssertTrue(result?.contains("name TEXT") == true)
        XCTAssertTrue(result?.contains("age INTEGER") == true)
    }

    func testCreateTableStatementWithPrimaryKey() {
        let statement = CreateTableStatement(with: "TestTable")
            .addColumn(with: "id", type: .text(""))
            .withPrimaryKey()
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.contains("CONSTRAINT unqTestTable UNIQUE") == true)
    }

    func testCreateTableStatementWithoutPrimaryKey() {
        let statement = CreateTableStatement(with: "TestTable")
            .addColumn(with: "id", type: .text(""))
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertFalse(result?.contains("CONSTRAINT") == true)
    }

    func testCreateTableStatementWithNoColumns() {
        let statement = CreateTableStatement(with: "EmptyTable")
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.contains("CREATE TABLE IF NOT EXISTS EmptyTable") == true)
        XCTAssertTrue(result?.hasSuffix(");") == true)
    }

    func testCreateTableStatementWithDoubleColumn() {
        let statement = CreateTableStatement(with: "TestTable")
            .addColumn(with: "price", type: .double(0))
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.contains("price DOUBLE") == true)
    }

    func testCreateTableStatementWithBlobColumn() {
        let statement = CreateTableStatement(with: "TestTable")
            .addColumn(with: "data", type: .blob(nil))
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.contains("data BLOB") == true)
    }
}
