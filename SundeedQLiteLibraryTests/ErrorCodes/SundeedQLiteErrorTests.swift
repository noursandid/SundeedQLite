//
//  SundeedQLiteErrorTests.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 10/8/19.
//  Copyright © 2019 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class SundeedQLiteErrorTests: XCTestCase {
    var error: SundeedQLiteError?
    var employer: EmployerForTesting = EmployerForTesting()
    
    override func setUp() {
        self.employer.fillData()
    }
    override func tearDown() async throws {
        try await self.employer.delete(deleteSubObjects: true)
        error = nil
    }

    func testPrimaryKeyError() {
        error = .primaryKeyError(tableName: employer.getTableName())
        let errorString = "Error with class \(employer.getTableName()): \n No Primary Key \n - To add a primary key add a '+' sign in the mapping function in the class after the designated primary map \n  e.g: self.id = map[\"ID\"]+"
        XCTAssertEqual(error?.description, errorString)
    }
    
    func testUnsupportedTypeError() {
        error = .unsupportedType(tableName: employer.getTableName(), attribute: "Test")
        let errorString = "Error with class \(employer.getTableName()): \n Unsupported Type Test \n - Try to change the type of this attribute, or send us a suggestion so we can add it"
        XCTAssertEqual(error?.description, errorString)
    }
    
    func testNoColumnWithThisNameError() {
        error = .noColumnWithThisName(tableName: employer.getTableName(), columnName: "Test")
        let errorString = "Error with class \(employer.getTableName()): \n No Column With Title Test \n - Try to change the column name and try again"
        XCTAssertEqual(error?.description, errorString)
    }
    
    func testCantUseNameIndexError() {
        error = .cantUseNameIndex(tableName: employer.getTableName())
        let errorString = "Error with class \(employer.getTableName()): \n Unsupported column name \"index\" because it is reserved \n - Try to change it and try again"
        XCTAssertEqual(error?.description, errorString)
    }
    
    func testNoChangesMadeError() {
        error = .noChangesMade(tableName: employer.getTableName())
        let errorString = "Error with class \(employer.getTableName()): \n Trying to perform global update statement with no changes \n - Try to add some changes and try again"
        XCTAssertEqual(error?.description, errorString)
    }
    
    func testErrorInNoObjectError() {
        error = .noObjectPassed
        let errorString = "Error no object passed to handle"
        XCTAssertEqual(error?.description, errorString)
    }
    
    func testErrorInConnectionError() {
        error = .errorInConnection
        let errorString = "Error with Connection: \n Unable to create a connection to the local database \n Make sure that you have access and permissions to device's files"
        XCTAssertEqual(error?.description, errorString)
    }
    
    func testErrorInAccessDocumentDirectory() {
        error = .cannotAccessDocumentDirectory
        let errorString = "Error with Document Directory: Cannot Access Document Directory"
        XCTAssertEqual(error?.description, errorString)
    }
}
