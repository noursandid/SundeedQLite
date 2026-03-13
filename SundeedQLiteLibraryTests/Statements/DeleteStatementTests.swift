//
//  DeleteStatementTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class DeleteStatementTests: XCTestCase {
    func testDeleteWithNoFilter() {
        let query = DeleteStatement(with: "TestTable").build()
        XCTAssertEqual(query, "DELETE FROM TestTable WHERE 1")
    }

    func testDeleteWithSingleFilter() {
        let filter = SundeedColumn("id") == "123"
        let query = DeleteStatement(with: "TestTable")
            .withFilters([filter])
            .build()
        XCTAssertEqual(query, "DELETE FROM TestTable WHERE id = '123'")
    }

    func testDeleteWithMultipleFilters() {
        let filter1 = SundeedColumn("id") == "123"
        let filter2 = SundeedColumn("name") == "test"
        let query = DeleteStatement(with: "TestTable")
            .withFilters([filter1, filter2])
            .build()
        XCTAssertEqual(query, "DELETE FROM TestTable WHERE id = '123' AND name = 'test'")
    }

    func testDeleteWithNilFiltersCompacted() {
        let filter1 = SundeedColumn("id") == "123"
        let query = DeleteStatement(with: "TestTable")
            .withFilters([filter1, nil])
            .build()
        XCTAssertEqual(query, "DELETE FROM TestTable WHERE id = '123'")
    }

    func testDeleteWithAllNilFilters() {
        let query = DeleteStatement(with: "TestTable")
            .withFilters([nil, nil])
            .build()
        XCTAssertEqual(query, "DELETE FROM TestTable WHERE 1")
    }
}
