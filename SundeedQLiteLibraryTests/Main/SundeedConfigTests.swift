//
//  SundeedConfigTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class SundeedConfigTests: XCTestCase {
    func testSharedInstance() {
        let shared1 = Sundeed.shared
        let shared2 = Sundeed.shared
        XCTAssertTrue(shared1 === shared2)
    }

    func testDatabaseFileName() {
        XCTAssertEqual(Sundeed.shared.databaseFileName, "SQLiteDB.sqlite")
    }

    func testPrimaryKey() {
        XCTAssertEqual(Sundeed.shared.primaryKey, "SUNDEED_UNIQUE_KEY")
    }

    func testForeignKey() {
        XCTAssertEqual(Sundeed.shared.foreignKey, "SUNDEED_FOREIGN_KEY")
    }

    func testFieldNameLink() {
        XCTAssertEqual(Sundeed.shared.fieldNameLink, "SUNDEED_FIELD_NAME_LINK")
    }

    func testOfflineID() {
        XCTAssertEqual(Sundeed.shared.offlineID, "SUNDEED_OFFLINE_ID")
    }

    func testForeignPrefix() {
        XCTAssertEqual(Sundeed.shared.foreignPrefix, "SUNDEED_FOREIGN|")
    }

    func testForeignPrimitivePrefix() {
        XCTAssertEqual(Sundeed.shared.foreignPrimitivePrefix, "SUNDEED_PRIMITIVE_FOREIGN|")
    }

    func testTopLevelSentinel() {
        XCTAssertEqual(Sundeed.shared.topLevelSentinel, "")
    }

    func testDatabaseNull() {
        XCTAssertEqual(Sundeed.shared.databaseNull, "<null>")
    }

    func testValueColumnName() {
        XCTAssertEqual(Sundeed.shared.valueColumnName, "VALUE")
    }

    func testSundeedForeignValueWithSubObjectPrimaryKey() {
        let result = Sundeed.shared.sundeedForeignValue(tableName: "Employee", fieldNameLink: "object", subObjectPrimaryKey: "EMP1")
        XCTAssertEqual(result, "SUNDEED_FOREIGN|Employee|object|EMP1")
    }

    func testSundeedForeignValueWithoutSubObjectPrimaryKey() {
        let result = Sundeed.shared.sundeedForeignValue(tableName: "Employee", fieldNameLink: "object")
        XCTAssertEqual(result, "SUNDEED_FOREIGN|Employee|object")
    }

    func testSundeedPrimitiveForeignValue() {
        let result = Sundeed.shared.sundeedPrimitiveForeignValue(tableName: "TestTable")
        XCTAssertEqual(result, "SUNDEED_PRIMITIVE_FOREIGN|TestTable")
    }

    func testTablesArray() {
        let initialCount = Sundeed.shared.tables.count
        Sundeed.shared.tables.append("TestTable123")
        XCTAssertEqual(Sundeed.shared.tables.count, initialCount + 1)
        Sundeed.shared.tables.removeAll(where: { $0 == "TestTable123" })
    }
}
