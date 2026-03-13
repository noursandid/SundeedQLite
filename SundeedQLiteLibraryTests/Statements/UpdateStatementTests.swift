//
//  UpdateStatementTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class UpdateStatementTests: XCTestCase {
    func testUpdateWithNoKeyValues() {
        let statement = UpdateStatement(with: "TestTable")
        let result = statement.build()
        XCTAssertNil(result)
    }

    func testUpdateWithFilters() {
        let statement = UpdateStatement(with: "TestTable")
            .add(key: "name", value: "newValue")
            .withFilters([SundeedColumn("id") == "123"])
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.query.contains("WHERE id = '123'") == true)
    }

    func testUpdateWithMultipleFilters() {
        let filter1 = SundeedColumn("id") == "123"
        let filter2 = SundeedColumn("active") == true
        let statement = UpdateStatement(with: "TestTable")
            .add(key: "name", value: "newValue")
            .withFilters([filter1, filter2])
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.query.contains(" AND ") == true)
    }

    func testUpdateWithNilFilters() {
        let statement = UpdateStatement(with: "TestTable")
            .add(key: "name", value: "newValue")
            .withFilters([nil, nil])
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.query.contains("WHERE 1") == true)
    }

    func testUpdateWithNilValue() {
        let statement = UpdateStatement(with: "TestTable")
            .add(key: "name", value: nil)
        let result = statement.build()
        XCTAssertNotNil(result)
    }

    func testUpdateMultipleKeyValues() {
        let statement = UpdateStatement(with: "TestTable")
            .add(key: "col1", value: "val1")
            .add(key: "col2", value: 42)
            .add(key: "col3", value: 3.14)
        let result = statement.build()
        XCTAssertNotNil(result)
    }
}
