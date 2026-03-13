//
//  SelectStatementTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class SelectStatementTests: XCTestCase {
    func testSkipWithoutLimitAddsLimitMinusOne() {
        let query = StatementBuilder()
            .selectStatement(tableName: "T")
            .isOrdered(true)
            .orderBy(columnName: "integer")
            .isAscending(true)
            .skip(1)
            .build()
        XCTAssertNotNil(query)
        XCTAssertTrue(query?.contains(" LIMIT -1 OFFSET 1") == true, query ?? "")
    }

    func testBasicSelect() {
        let query = SelectStatement(with: "TestTable").build()
        XCTAssertNotNil(query)
        XCTAssertTrue(query?.contains("SELECT * FROM TestTable") == true)
    }

    func testSelectWithLimit() {
        let query = SelectStatement(with: "T").limit(10).build()
        XCTAssertTrue(query?.contains("LIMIT 10") == true)
    }

    func testSelectWithLimitAndSkip() {
        let query = SelectStatement(with: "T").limit(10).skip(5).build()
        XCTAssertTrue(query?.contains("LIMIT 10") == true)
        XCTAssertTrue(query?.contains("OFFSET 5") == true)
    }

    func testSelectWithFilters() {
        let query = SelectStatement(with: "T")
            .withFilters([SundeedColumn("id") == "1"])
            .build()
        XCTAssertTrue(query?.contains("WHERE id = '1'") == true)
    }

    func testSelectDescending() {
        let query = SelectStatement(with: "T")
            .isAscending(false)
            .build()
        XCTAssertTrue(query?.contains("DESC") == true)
    }

    func testSelectAscending() {
        let query = SelectStatement(with: "T")
            .isAscending(true)
            .build()
        XCTAssertTrue(query?.contains("ASC") == true)
    }

    func testSelectCaseInsensitive() {
        let query = SelectStatement(with: "T")
            .isCaseInsensitive(true)
            .build()
        XCTAssertTrue(query?.contains("COLLATE NOCASE") == true)
    }

    func testSelectCaseSensitive() {
        let query = SelectStatement(with: "T")
            .isCaseInsensitive(false)
            .build()
        XCTAssertFalse(query?.contains("COLLATE NOCASE") == true)
    }

    func testSelectWithOrderByColumn() {
        let query = SelectStatement(with: "T")
            .isOrdered(true)
            .orderBy(columnName: "name")
            .build()
        XCTAssertTrue(query?.contains("ORDER BY name") == true)
    }

    func testSelectWithoutOrderUsesOfflineID() {
        let query = SelectStatement(with: "T").build()
        XCTAssertTrue(query?.contains("ORDER BY SUNDEED_OFFLINE_ID") == true)
    }

    func testSelectExcludeIfIsForeign() {
        let query = SelectStatement(with: "T")
            .excludeIfIsForeign(true)
            .build()
        XCTAssertTrue(query?.contains("SUNDEED_FOREIGN_KEY") == true)
    }

    func testSelectExcludeIfIsForeignFalse() {
        let query = SelectStatement(with: "T")
            .excludeIfIsForeign(false)
            .build()
        XCTAssertFalse(query?.contains("SUNDEED_FOREIGN_KEY") == true)
    }

    func testSelectWithVariadicFilters() {
        let f1 = SundeedColumn("a") == "1"
        let f2 = SundeedColumn("b") == "2"
        let query = SelectStatement(with: "T")
            .withFilters(f1, f2)
            .build()
        XCTAssertTrue(query?.contains("AND") == true)
    }
}
