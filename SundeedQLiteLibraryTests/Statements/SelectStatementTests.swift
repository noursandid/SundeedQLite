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
}


