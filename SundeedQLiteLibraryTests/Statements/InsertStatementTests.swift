//
//  InsertStatementTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class InsertStatementTests: XCTestCase {
    override func tearDown() async throws {
        await EmployerForTesting.delete()
        await EmployeeForTesting.delete()
    }

    func testInsertStatementBuildWithNoKeyValues() {
        let statement = InsertStatement(with: "NonExistentTable")
        let result = statement.build()
        XCTAssertNil(result)
    }

    func testInsertStatementBuildWithKeyValues() {
        let statement = InsertStatement(with: "NonExistentTable")
            .add(key: "name", value: "test")
            .add(key: "age", value: 25)
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.query.contains("REPLACE INTO NonExistentTable") == true)
        XCTAssertTrue(result?.query.contains("VALUES") == true)
    }

    func testInsertStatementMultipleKeys() {
        let statement = InsertStatement(with: "TestTable")
            .add(key: "col1", value: "val1")
            .add(key: "col2", value: "val2")
            .add(key: "col3", value: "val3")
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.parameters.count, 3)
    }

    func testInsertStatementWithNilValue() {
        let statement = InsertStatement(with: "TestTable")
            .add(key: "col1", value: nil)
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.parameters.count, 1)
    }
}
