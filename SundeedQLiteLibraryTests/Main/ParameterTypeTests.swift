//
//  ParameterTypeTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class ParameterTypeTests: XCTestCase {
    // MARK: - rawValue
    func testRawValueText() {
        XCTAssertEqual(ParameterType.text("hello").rawValue, "TEXT")
    }
    func testRawValueBlob() {
        XCTAssertEqual(ParameterType.blob(nil).rawValue, "BLOB")
    }
    func testRawValueInteger() {
        XCTAssertEqual(ParameterType.integer(42).rawValue, "INTEGER")
    }
    func testRawValueDouble() {
        XCTAssertEqual(ParameterType.double(3.14).rawValue, "DOUBLE")
    }

    // MARK: - init(typeString:value:)
    func testInitBlobType() {
        let data = "test".data(using: .utf8)
        let param = ParameterType(typeString: "BLOB", value: data)
        if case .blob(let d) = param {
            XCTAssertEqual(d, data)
        } else {
            XCTFail("Expected blob type")
        }
    }
    func testInitBlobTypeWithNilValue() {
        let param = ParameterType(typeString: "BLOB", value: nil)
        if case .blob(let d) = param {
            XCTAssertEqual(d, Data())
        } else {
            XCTFail("Expected blob type")
        }
    }
    func testInitIntegerType() {
        let param = ParameterType(typeString: "INTEGER", value: 42)
        if case .integer(let i) = param {
            XCTAssertEqual(i, 42)
        } else {
            XCTFail("Expected integer type")
        }
    }
    func testInitIntegerTypeWithNilValue() {
        let param = ParameterType(typeString: "INTEGER", value: nil)
        if case .integer(let i) = param {
            XCTAssertEqual(i, 0)
        } else {
            XCTFail("Expected integer type")
        }
    }
    func testInitDoubleType() {
        let param = ParameterType(typeString: "DOUBLE", value: 3.14)
        if case .double(let d) = param {
            XCTAssertEqual(d, 3.14)
        } else {
            XCTFail("Expected double type")
        }
    }
    func testInitDoubleTypeWithNilValue() {
        let param = ParameterType(typeString: "DOUBLE", value: nil)
        if case .double(let d) = param {
            XCTAssertEqual(d, 0)
        } else {
            XCTFail("Expected double type")
        }
    }
    func testInitDefaultTextType() {
        let param = ParameterType(typeString: "UNKNOWN", value: "hello")
        if case .text(let t) = param {
            XCTAssertEqual(t, "hello")
        } else {
            XCTFail("Expected text type")
        }
    }
    func testInitDefaultTextTypeWithNilValue() {
        let param = ParameterType(typeString: "WHATEVER", value: nil)
        if case .text(let t) = param {
            XCTAssertEqual(t, "")
        } else {
            XCTFail("Expected text type")
        }
    }

    // MARK: - withValue
    func testWithValueBlob() {
        let data = "blob".data(using: .utf8)
        let result = ParameterType.blob(nil).withValue(data)
        if case .blob(let d) = result {
            XCTAssertEqual(d, data)
        } else {
            XCTFail("Expected blob")
        }
    }
    func testWithValueBlobNil() {
        let result = ParameterType.blob(nil).withValue(nil)
        if case .blob(let d) = result {
            XCTAssertNil(d)
        } else {
            XCTFail("Expected blob")
        }
    }
    func testWithValueInteger() {
        let result = ParameterType.integer(0).withValue(NSNumber(value: 99))
        if case .integer(let i) = result {
            XCTAssertEqual(i, 99)
        } else {
            XCTFail("Expected integer")
        }
    }
    func testWithValueIntegerNil() {
        let result = ParameterType.integer(0).withValue(nil)
        if case .integer(let i) = result {
            XCTAssertNil(i)
        } else {
            XCTFail("Expected integer")
        }
    }
    func testWithValueIntegerNonNumber() {
        let result = ParameterType.integer(0).withValue("notANumber")
        if case .integer(let i) = result {
            XCTAssertNil(i)
        } else {
            XCTFail("Expected integer")
        }
    }
    func testWithValueDouble() {
        let result = ParameterType.double(0).withValue(NSNumber(value: 2.718))
        if case .double(let d) = result {
            XCTAssertEqual(d!, 2.718, accuracy: 0.001)
        } else {
            XCTFail("Expected double")
        }
    }
    func testWithValueDoubleNil() {
        let result = ParameterType.double(0).withValue(nil)
        if case .double(let d) = result {
            XCTAssertNil(d)
        } else {
            XCTFail("Expected double")
        }
    }
    func testWithValueDoubleNonNumber() {
        let result = ParameterType.double(0).withValue("notANumber")
        if case .double(let d) = result {
            XCTAssertNil(d)
        } else {
            XCTFail("Expected double")
        }
    }
    func testWithValueText() {
        let result = ParameterType.text("").withValue("hello")
        if case .text(let t) = result {
            XCTAssertEqual(t, "hello")
        } else {
            XCTFail("Expected text")
        }
    }
    func testWithValueTextNil() {
        let result = ParameterType.text("").withValue(nil)
        if case .text(let t) = result {
            XCTAssertNil(t)
        } else {
            XCTFail("Expected text")
        }
    }
    func testWithValueTextFromInt() {
        let result = ParameterType.text("").withValue(42)
        if case .text(let t) = result {
            XCTAssertEqual(t, "42")
        } else {
            XCTFail("Expected text")
        }
    }
}
