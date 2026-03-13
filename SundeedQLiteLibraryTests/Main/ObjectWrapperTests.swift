//
//  ObjectWrapperTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class ObjectWrapperTests: XCTestCase {
    func testInitWithAllParameters() {
        let wrapper = ObjectWrapper(tableName: "TestTable",
                                     className: "TestClass",
                                     objects: ["key": "value"],
                                     types: ["key": .text("")],
                                     isOrdered: true,
                                     orderBy: "name",
                                     asc: true,
                                     hasPrimaryKey: true)
        XCTAssertEqual(wrapper.tableName, "TestTable")
        XCTAssertEqual(wrapper.className, "TestClass")
        XCTAssertNotNil(wrapper.objects)
        XCTAssertNotNil(wrapper.types)
        XCTAssertTrue(wrapper.isOrdered)
        XCTAssertEqual(wrapper.orderBy, "name")
        XCTAssertTrue(wrapper.asc)
        XCTAssertTrue(wrapper.hasPrimaryKey)
    }

    func testInitWithDefaults() {
        let wrapper = ObjectWrapper(tableName: "TestTable",
                                     className: nil,
                                     objects: nil,
                                     types: nil)
        XCTAssertEqual(wrapper.tableName, "TestTable")
        XCTAssertNil(wrapper.className)
        XCTAssertNil(wrapper.objects)
        XCTAssertNil(wrapper.types)
        XCTAssertFalse(wrapper.isOrdered)
        XCTAssertEqual(wrapper.orderBy, "")
        XCTAssertFalse(wrapper.asc)
        XCTAssertFalse(wrapper.hasPrimaryKey)
    }

    func testObjectsMutability() {
        let wrapper = ObjectWrapper(tableName: "T",
                                     className: "C",
                                     objects: ["a": 1],
                                     types: nil)
        wrapper.objects?["b"] = 2
        XCTAssertEqual(wrapper.objects?["b"] as? Int, 2)
    }
}
