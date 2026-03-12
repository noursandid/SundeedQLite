//
//  SundeedQLiteModelMacroTests.swift
//  SundeedQLiteMacroTests
//
//  Created by SundeedQLite on 2026.
//  Copyright © 2026 LUMBERCODE. All rights reserved.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
@testable import SundeedQLiteMacrosPlugin

let testMacros: [String: Macro.Type] = [
    "SundeedQLiteModel": SundeedQLiteModelMacro.self,
    "Primary": SundeedQLitePeerMacro.self,
    "Ordered": SundeedQLitePeerMacro.self,
    "Mandatory": SundeedQLitePeerMacro.self,
    "MandatoryArray": SundeedQLitePeerMacro.self,
    "Column": SundeedQLitePeerMacro.self,
    "Converted": SundeedQLitePeerMacro.self,
    "Ignore": SundeedQLitePeerMacro.self,
]

final class SundeedQLiteModelMacroTests: XCTestCase {

    // MARK: - Basic Model

    func testBasicModel() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                var id: String!
                var name: String?
                var age: Int?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var name: String?
                var age: Int?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]
                    name <~> map["name"]
                    age <~> map["age"]
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - Primary Key

    func testPrimaryKey() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary var id: String!
                var name: String?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var name: String?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    name <~> map["name"]
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - Ordering

    func testOrderedAscending() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary var id: String!
                @Ordered(.ascending) var name: String?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var name: String?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    name <~> map["name"]<<
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    func testOrderedDescending() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary var id: String!
                @Ordered(.descending) var createdAt: Date?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var createdAt: Date?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    createdAt <~> map["createdAt"]>>
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - Mandatory

    func testMandatory() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary var id: String!
                @Mandatory var name: String?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var name: String?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    name <*> map["name"]
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - MandatoryArray

    func testMandatoryArray() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Team {
                @Primary var id: String!
                @MandatoryArray var members: [Employee]?
            }
            """,
            expandedSource: """
            class Team {
                var id: String!
                var members: [Employee]?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    members <**> map["members"]
                }
            }

            extension Team: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - Column Override

    func testColumnName() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary @Column("employee_id") var id: String!
                @Column("full_name") var name: String?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var name: String?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["employee_id"]+
                    name <~> map["full_name"]
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - Converter

    func testConverter() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary var id: String!
                @Converted(TypeConverter.self) var type: Type?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var type: Type?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    type <~> (map["type"], TypeConverter())
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    func testMandatoryConverter() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary var id: String!
                @Mandatory @Converted(TypeConverter.self) var type: Type?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var type: Type?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    type <*> (map["type"], TypeConverter())
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - Ignore

    func testIgnore() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary var id: String!
                var name: String?
                @Ignore var transient: Int = 0
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var name: String?
                var transient: Int = 0

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    name <~> map["name"]
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - All Types Combined

    func testAllTypesCombined() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class FullModel {
                @Primary @Ordered(.ascending) var id: String!
                @Mandatory var name: String?
                var salary: Double?
                var isActive: Bool?
                var data: Data?
                var profileImage: UIImage?
                var hireDate: Date?
                @Converted(TypeConverter.self) var type: Type?
                var manager: Employee?
                var reports: [Employee]?
                @MandatoryArray var skills: [Skill]?
                @Column("dept_name") var department: String?
                @Ignore var tempValue: Int = 0
            }
            """,
            expandedSource: """
            class FullModel {
                var id: String!
                var name: String?
                var salary: Double?
                var isActive: Bool?
                var data: Data?
                var profileImage: UIImage?
                var hireDate: Date?
                var type: Type?
                var manager: Employee?
                var reports: [Employee]?
                var skills: [Skill]?
                var department: String?
                var tempValue: Int = 0

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+<<
                    name <*> map["name"]
                    salary <~> map["salary"]
                    isActive <~> map["isActive"]
                    data <~> map["data"]
                    profileImage <~> map["profileImage"]
                    hireDate <~> map["hireDate"]
                    type <~> (map["type"], TypeConverter())
                    manager <~> map["manager"]
                    reports <~> map["reports"]
                    skills <**> map["skills"]
                    department <~> map["dept_name"]
                }
            }

            extension FullModel: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - Diagnostics

    func testNotAClass() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            struct NotAClass {
                var id: String!
            }
            """,
            expandedSource: """
            struct NotAClass {
                var id: String!
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@SundeedQLiteModel can only be applied to classes",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }

    func testMultiplePrimaryKeys() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class BadModel {
                @Primary var id: String!
                @Primary var otherId: String!
            }
            """,
            expandedSource: """
            class BadModel {
                var id: String!
                var otherId: String!
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "Only one property can be marked with @Primary",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }

    func testMultipleOrdered() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class BadModel {
                @Ordered(.ascending) var name: String?
                @Ordered(.descending) var age: Int?
            }
            """,
            expandedSource: """
            class BadModel {
                var name: String?
                var age: Int?
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "Only one property can be marked with @Ordered",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }

    func testMandatoryArrayOnPrimitiveArray() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class BadModel {
                @Primary var id: String!
                @MandatoryArray var names: [String]?
            }
            """,
            expandedSource: """
            class BadModel {
                var id: String!
                var names: [String]?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                }
            }

            extension BadModel: SundeedQLiter {
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@MandatoryArray can only be applied to arrays of SundeedQLiter-conforming types, not primitive arrays",
                    line: 4,
                    column: 5
                )
            ],
            macros: testMacros
        )
    }

    func testMandatoryAndMandatoryArrayConflict() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class BadModel {
                @Primary var id: String!
                @Mandatory @MandatoryArray var items: [Employee]?
            }
            """,
            expandedSource: """
            class BadModel {
                var id: String!
                var items: [Employee]?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                }
            }

            extension BadModel: SundeedQLiter {
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@Mandatory and @MandatoryArray cannot be applied to the same property",
                    line: 4,
                    column: 5
                )
            ],
            macros: testMacros
        )
    }

    // MARK: - Nested SundeedQLiter Objects

    func testNestedSundeedQLiterObjects() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employer {
                @Primary var id: String!
                var employee: Employee?
                var employees: [Employee]?
                var optionalEmployees: [Employee?]?
            }
            """,
            expandedSource: """
            class Employer {
                var id: String!
                var employee: Employee?
                var employees: [Employee]?
                var optionalEmployees: [Employee?]?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    employee <~> map["employee"]
                    employees <~> map["employees"]
                    optionalEmployees <~> map["optionalEmployees"]
                }
            }

            extension Employer: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - Primary + Ordered Combined

    func testPrimaryAndOrdered() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary @Ordered(.descending) var id: String!
                var name: String?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var name: String?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+>>
                    name <~> map["name"]
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - Converter with Column Override

    func testConverterWithColumnOverride() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class Employee {
                @Primary var id: String!
                @Converted(TypeConverter.self) @Column("employee_type") var type: Type?
            }
            """,
            expandedSource: """
            class Employee {
                var id: String!
                var type: Type?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    type <~> (map["employee_type"], TypeConverter())
                }
            }

            extension Employee: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - No Primary Key Model

    func testNoPrimaryKey() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class SimpleModel {
                var name: String?
                var value: Int?
            }
            """,
            expandedSource: """
            class SimpleModel {
                var name: String?
                var value: Int?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    name <~> map["name"]
                    value <~> map["value"]
                }
            }

            extension SimpleModel: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }

    // MARK: - All Primitive Types

    func testAllPrimitiveTypes() throws {
        assertMacroExpansion(
            """
            @SundeedQLiteModel
            class AllTypes {
                @Primary var id: String!
                var stringVal: String?
                var intVal: Int?
                var doubleVal: Double?
                var floatVal: Float?
                var boolVal: Bool?
                var dateVal: Date?
                var dataVal: Data?
                var imageVal: UIImage?
                var stringArray: [String]?
                var intArray: [Int]?
                var boolArray: [Bool]?
            }
            """,
            expandedSource: """
            class AllTypes {
                var id: String!
                var stringVal: String?
                var intVal: Int?
                var doubleVal: Double?
                var floatVal: Float?
                var boolVal: Bool?
                var dateVal: Date?
                var dataVal: Data?
                var imageVal: UIImage?
                var stringArray: [String]?
                var intArray: [Int]?
                var boolArray: [Bool]?

                required init() {
                }

                func sundeedQLiterMapping(map: SundeedQLiteMap) {
                    id <~> map["id"]+
                    stringVal <~> map["stringVal"]
                    intVal <~> map["intVal"]
                    doubleVal <~> map["doubleVal"]
                    floatVal <~> map["floatVal"]
                    boolVal <~> map["boolVal"]
                    dateVal <~> map["dateVal"]
                    dataVal <~> map["dataVal"]
                    imageVal <~> map["imageVal"]
                    stringArray <~> map["stringArray"]
                    intArray <~> map["intArray"]
                    boolArray <~> map["boolArray"]
                }
            }

            extension AllTypes: SundeedQLiter {
            }
            """,
            macros: testMacros
        )
    }
}
