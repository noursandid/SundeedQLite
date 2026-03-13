//
//  SundeedQLiteMapTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class SundeedQLiteMapTests: XCTestCase {
    override func tearDown() {
        SundeedQLiteMap.references.removeAll()
    }

    // MARK: - Subscript
    func testSubscriptExistingKey() {
        let map = SundeedQLiteMap(dictionnary: ["name": "Alice"])
        let result = map["name"]
        XCTAssertEqual(result.currentValue as? String, "Alice")
    }

    func testSubscriptNonExistingKey() {
        let map = SundeedQLiteMap(dictionnary: ["name": "Alice"])
        let result = map["age"]
        XCTAssertNil(result.currentValue)
    }

    func testSubscriptEmptyMap() {
        let map = SundeedQLiteMap(dictionnary: [:])
        let result = map["anything"]
        XCTAssertNil(result.currentValue)
    }

    // MARK: - addColumn
    func testAddColumn() {
        let map = SundeedQLiteMap(fetchingColumns: true)
        map.addColumn(attribute: "Hello", withColumnName: "greeting", type: .text(""))
        XCTAssertEqual(map.columns["greeting"] as? String, "Hello")
        if case .text = map.types["greeting"] {
            // pass
        } else {
            XCTFail("Expected text type")
        }
    }

    func testAddColumnWithPrimaryKey() {
        let map = SundeedQLiteMap(fetchingColumns: true)
        map.hasPrimaryKey = true
        map.primaryKey = "id"
        map.addColumn(attribute: "123", withColumnName: "id", type: .text(""))
        XCTAssertEqual(map.columns[Sundeed.shared.primaryKey] as? String, "123")
    }

    func testAddColumnNonPrimaryKey() {
        let map = SundeedQLiteMap(fetchingColumns: true)
        map.hasPrimaryKey = true
        map.primaryKey = "id"
        map.addColumn(attribute: "value", withColumnName: "other", type: .text(""))
        XCTAssertNil(map.columns[Sundeed.shared.primaryKey])
    }

    // MARK: - References
    func testAddAndGetReference() {
        let employee = EmployeeForTesting()
        employee.id = "EMP1"
        SundeedQLiteMap.addReference(object: employee, andValue: "EMP1" as AnyObject, andClassName: "TestClass")
        let ref = SundeedQLiteMap.getReference(andValue: "EMP1" as AnyObject, andClassName: "TestClass")
        XCTAssertNotNil(ref)
        XCTAssertTrue(ref is EmployeeForTesting)
    }

    func testGetReferenceNonExistentClass() {
        let ref = SundeedQLiteMap.getReference(andValue: "NONE" as AnyObject, andClassName: "NonExistent")
        XCTAssertNil(ref)
    }

    func testGetReferenceNonExistentValue() {
        let employee = EmployeeForTesting()
        SundeedQLiteMap.addReference(object: employee, andValue: "EMP1" as AnyObject, andClassName: "TestClass")
        let ref = SundeedQLiteMap.getReference(andValue: "EMP2" as AnyObject, andClassName: "TestClass")
        XCTAssertNil(ref)
    }

    func testRemoveReference() {
        let employee = EmployeeForTesting()
        SundeedQLiteMap.addReference(object: employee, andValue: "EMP1" as AnyObject, andClassName: "TestClass")
        SundeedQLiteMap.removeReference(value: "EMP1" as AnyObject, andClassName: "TestClass")
        let ref = SundeedQLiteMap.getReference(andValue: "EMP1" as AnyObject, andClassName: "TestClass")
        XCTAssertNil(ref)
    }

    func testAddReferenceDuplicate() {
        let employee1 = EmployeeForTesting()
        employee1.id = "EMP1"
        let employee2 = EmployeeForTesting()
        employee2.id = "EMP2"
        SundeedQLiteMap.addReference(object: employee1, andValue: "KEY" as AnyObject, andClassName: "TestClass")
        SundeedQLiteMap.addReference(object: employee2, andValue: "KEY" as AnyObject, andClassName: "TestClass")
        // Should keep the first one
        let ref = SundeedQLiteMap.getReference(andValue: "KEY" as AnyObject, andClassName: "TestClass") as? EmployeeForTesting
        XCTAssertEqual(ref?.id, "EMP1")
    }

    // MARK: - Init modes
    func testFetchingColumnsInit() {
        let map = SundeedQLiteMap(fetchingColumns: true)
        XCTAssertTrue(map.fetchingColumns)
        XCTAssertTrue(map.map.isEmpty)
    }

    func testDictionaryInit() {
        let map = SundeedQLiteMap(dictionnary: ["key": "value"])
        XCTAssertFalse(map.fetchingColumns)
        XCTAssertEqual(map.map["key"] as? String, "value")
    }

    // MARK: - isSafeToAdd
    func testIsSafeToAddDefaultTrue() {
        let map = SundeedQLiteMap(fetchingColumns: true)
        XCTAssertTrue(map.isSafeToAdd)
    }
}
