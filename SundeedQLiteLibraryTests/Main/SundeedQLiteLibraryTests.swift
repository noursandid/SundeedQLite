//
//  SundeedQLiteLibraryTests.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 10/5/19.
//  Copyright © 2019 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class SundeedQLiteLibraryTests: XCTestCase {
    override func tearDown() {
        SundeedQLite.deleteDatabase()
    }
    
    func testSubscript() {
        let employer = EmployerForTesting()
        employer.string = "string"
        guard let string = employer["string"] as? String else {
            XCTFail("Employer is nil")
            return
        }
        XCTAssertEqual(string, "string")
    }
    
    func testWrongSubscript() {
        let employer = EmployerForTesting()
        let string = employer["wrong"] as? String
        XCTAssertNil(string)
    }
    
    func testSundeedQLiteMap() {
        let employee = EmployeeForTesting()
        SundeedQLiteMap.references["Test"] = nil
        SundeedQLiteMap.addReference(object: employee,
                                     andValue: "ID_ID" as AnyObject,
                                     andClassName: "Test")
        if let reference = SundeedQLiteMap.references["Test"],
            let employeeRetrieved = reference["ID_ID"] as? EmployeeForTesting {
            XCTAssertEqual(employee.id, employeeRetrieved.id)
        } else {
            XCTFail("Reference nil")
        }
    }
    func testSaveProcessorAcceptData() {
        let object: String = ""
        XCTAssert(SaveProcessor().acceptDataType(forObject: object as AnyObject))
        let  object1: String? = ""
        XCTAssert(SaveProcessor().acceptDataType(forObject: object1 as AnyObject))
        let  object2: Int = 1
        XCTAssert(SaveProcessor().acceptDataType(forObject: object2 as AnyObject))
        let  object3: Int? = 1
        XCTAssert(SaveProcessor().acceptDataType(forObject: object3 as AnyObject))
        let  object4: Double = 1.0
        XCTAssert(SaveProcessor().acceptDataType(forObject: object4 as AnyObject))
        let  object5: Double? = 1.0
        XCTAssert(SaveProcessor().acceptDataType(forObject: object5 as AnyObject))
        let  object6: Float = 1.0
        XCTAssert(SaveProcessor().acceptDataType(forObject: object6 as AnyObject))
        let  object7: Float? = 1.0
        XCTAssert(SaveProcessor().acceptDataType(forObject: object7 as AnyObject))
        let  object8: Bool = true
        XCTAssert(SaveProcessor().acceptDataType(forObject: object8 as AnyObject))
        let  object9: Bool? = true
        XCTAssert(SaveProcessor().acceptDataType(forObject: object9 as AnyObject))
        let  object10: Date = Date()
        XCTAssert(SaveProcessor().acceptDataType(forObject: object10 as AnyObject))
        let  object11: Date? = Date()
        XCTAssert(SaveProcessor().acceptDataType(forObject: object11 as AnyObject))
        let  object12: UIImage = UIImage(named: "image")!
        XCTAssert(SaveProcessor().acceptDataType(forObject: object12 as AnyObject))
        let  object13: UIImage? = UIImage(named: "image")
        XCTAssert(SaveProcessor().acceptDataType(forObject: object13 as AnyObject))
        XCTAssertFalse(SaveProcessor().acceptDataType(forObject: nil))
        XCTAssertFalse(SaveProcessor().acceptDataType(forObject: Type.ceo as AnyObject))
    }
    
    func testRetrieveWithWrongTableName() {
        let objectWrapper = ObjectWrapper(tableName: "HHH",
                                          className: "HHH",
                                          objects: [:])
        let result = RetrieveProcessor().retrieve(objectWrapper: objectWrapper) { _ -> ObjectWrapper? in
            return nil
        }
        XCTAssertEqual(result.count, 0)
    }
    
    func testGetPrimitiveValuesWithWrongTableName() {
        let result = RetrieveProcessor().getPrimitiveValues(forTable: "WrongTableName",
                                                            withFilter: nil)
        XCTAssertNil(result)
    }
    
    func testUpdateWithNoFilter() {
        let query = UpdateStatement(with: "table")
            .add(key: "column1", value: "value1")
            .build()
        XCTAssertEqual(query, "UPDATE table SET column1 = \'value1\' WHERE 1")
    }
    
    func testDeleteWithNoFilter() {
        let query = DeleteStatement(with: "table")
            .build()
        XCTAssertEqual(query, "DELETE FROM table WHERE 1")
    }
    
    func testQuotationsChange() {
        let quotationForSingleQuote = Statement().getQuotation(forValue: "trying ''")
        XCTAssertEqual(quotationForSingleQuote, "\"")
        let quotationForDoubleQuote = Statement().getQuotation(forValue: "trying \"\"")
        XCTAssertEqual(quotationForDoubleQuote, "\'")
    }
    
    func testClassToObjectWrapperWithWrongClass() {
        let wrapper = SundeedQLite.instance.classToObjectWrapper("WrongClass")
        XCTAssertNil(wrapper)
    }
    
    func testDeleteWithNoPrimary() {
        do {
            _ = try SundeedQLite.instance.deleteFromDB(object: ClassWithNoPrimary(), deleteSubObjects: false)
            XCTFail("Shouldn't continue")
        } catch {
            guard let sundeedError = error as? SundeedQLiteError else {
                XCTFail("Wrong Error")
                return
            }
            XCTAssertEqual(sundeedError.description, SundeedQLiteError.primaryKeyError(tableName: "ClassWithNoPrimary").description)
        }
    }
    
    func testCreateTableWithNilObjectWrapper() {
        let objectWrapper = ObjectWrapper(tableName: "Table",
                                          className: "Class",
                                          objects: nil)
        do {
            try CreateTableProcessor().createTableIfNeeded(for: objectWrapper)
            XCTFail("Weirdly it continued without throwing an error")
        } catch {
            guard let sundeedError = error as? SundeedQLiteError else {
                XCTFail("Wrong Error")
                return
            }
            XCTAssertEqual(sundeedError.description, SundeedQLiteError.noObjectPassed.description)
        }
    }
}
