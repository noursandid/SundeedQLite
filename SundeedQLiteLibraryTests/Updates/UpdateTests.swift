//
//  UpdateTests.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class UpdateTests: XCTestCase {
    var employer: EmployerForTesting? = EmployerForTesting()
    
    override func setUp() {
        employer?.fillData()
    }
    override func tearDown() {
        SundeedQLite.deleteDatabase()
    }
    
    func testGlobalUpdate() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        employer?.save {
            do {
                try EmployerForTesting.update(changes: SundeedColumn("optionalString") <~ "test",
                                              withFilter: SundeedColumn("string") == "string")  {
                    EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "string",
                                                completion: { (allEmployers) in
                                                    guard let employer = allEmployers.first else {
                                                        XCTFail("Couldn't Retrieve From Database")
                                                        return
                                                    }
                                                    XCTAssert(employer.optionalString == "test")
                                                    expectation.fulfill()
                    })
                }
            } catch {
                XCTFail("Couldn't update Global Employer Table \(error)")
            }
        }
        wait(for: [expectation], timeout: 8.0)
    }
    
    
    func testUpdate() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        employer?.save {
            do {
                self.employer?.optionalString = "test"
                self.employer?.object.firstName = "testtt"
                self.employer?.arrayOfStrings.append("Hello")
                self.employer?.arrayOfOptionalImages.append(UIImage(named: "1"))
                self.employer?.arrayOfImages.append(UIImage(named: "5")!)
                self.employer?.nilImage = UIImage(named: "3")!
                self.employer?.nilDate = Date()
                let employee = EmployeeForTesting(id: "LLLLLLL")
                self.employer?.arrayOfObjects.append(employee)
                try self.employer?.update(columns: SundeedColumn("optionalString"),
                                          SundeedColumn("object"),
                                          SundeedColumn("arrayOfStrings"),
                                          SundeedColumn("arrayOfOptionalImages"),
                                          SundeedColumn("arrayOfImages"),
                                          SundeedColumn("nilImage"),
                                          SundeedColumn("nilDate"),
                                          SundeedColumn("arrayOfObjects")
                )  {
                    EmployerForTesting.retrieve(completion: { (allEmployers) in
                        guard let employer1 = allEmployers.first else {
                            XCTFail("Couldn't Retrieve From Database")
                            return
                        }
                        XCTAssert(employer1.optionalString == "test")
                        XCTAssert(employer1.object.firstName == "testtt")
                        XCTAssert(employer1.arrayOfStrings.contains("Hello"))
                        XCTAssert(employer1.arrayOfOptionalImages.count == 2)
                        XCTAssertEqual(employer1.arrayOfOptionalImages.first??.jpegData(compressionQuality: 1)?.description,
                                       UIImage(named: "5")?.jpegData(compressionQuality: 1)?.description)
                        XCTAssertEqual(employer1.arrayOfOptionalImages[1]?.jpegData(compressionQuality: 1)?.description,
                                       UIImage(named: "1")?.jpegData(compressionQuality: 1)?.description)
                        XCTAssert(employer1.arrayOfImages.count == 3)
                        XCTAssertEqual(employer1.arrayOfImages.first?.jpegData(compressionQuality: 1)?.description,
                                       UIImage(named: "3")?.jpegData(compressionQuality: 1)?.description)
                        XCTAssertEqual(employer1.arrayOfImages[1].jpegData(compressionQuality: 1)?.description,
                                       UIImage(named: "4")?.jpegData(compressionQuality: 1)?.description)
                        XCTAssertEqual(employer1.arrayOfImages[2].jpegData(compressionQuality: 1)?.description,
                                       UIImage(named: "5")?.jpegData(compressionQuality: 1)?.description)
                        XCTAssertNotNil(employer1.nilImage)
                        XCTAssertEqual(employer1.nilImage?.jpegData(compressionQuality: 1)?.description,
                                       UIImage(named: "3")?.jpegData(compressionQuality: 1)?.description)
                        XCTAssertNotNil(employer1.nilDate)
                        XCTAssert(employer1.arrayOfObjects.contains(where: {$0.id == "LLLLLLL" }))
                        expectation.fulfill()
                    })
                }
            } catch {
                guard let sundeedError = error as? SundeedQLiteError else {
                    XCTFail("Wrong Error")
                    return
                }
                XCTFail(sundeedError.description)
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWrongColumnNameUpdate() {
        do {
            try self.employer?.update(columns: SundeedColumn("wrongColumnName"))
        } catch {
            guard let sundeedError = error as? SundeedQLiteError else {
                XCTFail("Wrong Error")
                return
            }
            XCTAssert(sundeedError.description == SundeedQLiteError.noColumnWithThisName(tableName: "EmployerForTesting",
                columnName: "wrongColumnName").description)
        }
    }
}
