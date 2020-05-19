//
//  OperationTests.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/16/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class OperationTests: XCTestCase {
    var employer: EmployerForTesting? = EmployerForTesting()
    
    override func setUp() {
        EmployerForTesting.delete()
        EmployeeForTesting.delete()
        employer?.fillData()
        employer?.save()
    }
    override class func tearDown() {
        SundeedQLite.deleteDatabase()
        UserDefaults.standard.removeObject(forKey: Sundeed.shared.shouldCopyDatabaseToFilePathKey)
    }
    
    func testDeleting() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            do {
                if try !(self.employer?.delete() ?? false) {
                    XCTFail("Couldn't delete class")
                } else {
                    
                }
            } catch {
                XCTFail("Couldn't delete class")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(completion: { (allEmployers) in
                    XCTAssert(allEmployers.isEmpty)
                    expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 6.0)
    }
    
    func testDeletingAll() {
        let expectation = XCTestExpectation(description: "Deleted Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            EmployerForTesting.delete()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(completion: { (allEmployers) in
                    XCTAssert(allEmployers.isEmpty)
                    expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 6.0)
    }
    
    func testRetrieve() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            EmployerForTesting.retrieve(completion: { (allEmployers) in
                guard let employer = allEmployers.first else {
                    XCTFail("Couldn't Retrieve From Database")
                    return
                }
                self.checkEmployer(employer)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 4.0)
    }
    
    func testRetrieveWithFilter() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "string",
                                        completion: { (allEmployers) in
                                            guard let employer = allEmployers.first else {
                                                XCTFail("Couldn't Retrieve From Database")
                                                return
                                            }
                                            self.checkEmployer(employer)
                                            expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRetrieveWithWrongFilter() {
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "ABCD",
                                        completion: { (allEmployers) in
                                            XCTAssertEqual(allEmployers.count, 0)
                                            expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func testRetrieveWithSortingIntAsc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let employer2 = EmployerForTesting()
            employer2.fillData()
            employer2.string = "str"
            employer2.integer = 2
            employer2.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(orderBy: SundeedColumn("integer"),
                                            ascending: true,
                                            completion: { (allEmployers) in
                                                XCTAssertEqual(allEmployers.count, 2)
                                                let firstEmployer = allEmployers[0]
                                                let secondEmployer = allEmployers[1]
                                                self.checkEmployer(firstEmployer)
                                                secondEmployer.integer = 2
                                                expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testRetrieveWithSortingIntDesc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let employer2 = EmployerForTesting()
            employer2.fillData()
            employer2.string = "stri"
            employer2.integer = 3
            employer2.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(orderBy: SundeedColumn("integer"),
                                            ascending: false,
                                            completion: { (allEmployers) in
                                                XCTAssertEqual(allEmployers.count, 2)
                                                let firstEmployer = allEmployers[0]
                                                let secondEmployer = allEmployers[1]
                                                firstEmployer.integer = 3
                                                self.checkEmployer(secondEmployer)
                                                expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testRetrieveWithSortingStringAsc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let employer2 = EmployerForTesting()
            employer2.fillData()
            employer2.string = "string2"
            employer2.integer = 2
            employer2.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(orderBy: SundeedColumn("string"),
                                            ascending: true,
                                            completion: { (allEmployers) in
                                                XCTAssertEqual(allEmployers.count, 2)
                                                let firstEmployer = allEmployers[0]
                                                let secondEmployer = allEmployers[1]
                                                self.checkEmployer(firstEmployer)
                                                secondEmployer.integer = 2
                                                expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testRetrieveWithSortingStringDesc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let employer2 = EmployerForTesting()
            employer2.fillData()
            employer2.string = "string3"
            employer2.integer = 3
            employer2.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                EmployerForTesting
                    .retrieve(orderBy: SundeedColumn("string"),
                              ascending: false,
                              completion: { (allEmployers) in
                                XCTAssertEqual(allEmployers.count, 2)
                                guard allEmployers.count == 2 else {
                                    XCTFail()
                                    return
                                }
                                let firstEmployer = allEmployers[0]
                                let secondEmployer = allEmployers[1]
                                firstEmployer.integer = 3
                                self.checkEmployer(secondEmployer)
                                expectation.fulfill()
                    })
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testRetrieveWithSortingDateAsc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let employer2 = EmployerForTesting()
            employer2.fillData()
            employer2.string = "string2"
            employer2.integer = 2
            employer2.date = Date().addingTimeInterval(500)
            employer2.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(orderBy: SundeedColumn("date"),
                                            ascending: true,
                                            completion: { (allEmployers) in
                                                XCTAssertEqual(allEmployers.count, 2)
                                                let firstEmployer = allEmployers[0]
                                                let secondEmployer = allEmployers[1]
                                                self.checkEmployer(firstEmployer)
                                                secondEmployer.integer = 2
                                                expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testRetrieveWithSortingDateDesc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let employer2 = EmployerForTesting()
            employer2.fillData()
            employer2.string = "string3"
            employer2.integer = 3
            employer2.date = Date().addingTimeInterval(500)
            employer2.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(orderBy: SundeedColumn("date"),
                                            ascending: false,
                                            completion: { (allEmployers) in
                                                XCTAssertEqual(allEmployers.count, 2)
                                                let firstEmployer = allEmployers[0]
                                                let secondEmployer = allEmployers[1]
                                                firstEmployer.integer = 3
                                                self.checkEmployer(secondEmployer)
                                                expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testRetrieveWithSortingEnumAsc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let employer2 = EmployerForTesting()
            employer2.fillData()
            employer2.string = "string2"
            employer2.integer = 2
            employer2.type = .ceo
            employer2.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(orderBy: SundeedColumn("type"),
                                            ascending: true,
                                            completion: { (allEmployers) in
                                                XCTAssertEqual(allEmployers.count, 2)
                                                let firstEmployer = allEmployers[0]
                                                let secondEmployer = allEmployers[1]
                                                self.checkEmployer(firstEmployer)
                                                secondEmployer.integer = 2
                                                expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testRetrieveWithSortingEnumDesc() {
        let expectation = XCTestExpectation(description: "Retrieve Sorted Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let employer2 = EmployerForTesting()
            employer2.fillData()
            employer2.string = "string3"
            employer2.integer = 3
            employer2.type = .ceo
            employer2.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                EmployerForTesting.retrieve(orderBy: SundeedColumn("type"),
                                            ascending: false,
                                            completion: { (allEmployers) in
                                                XCTAssertEqual(allEmployers.count, 2)
                                                let firstEmployer = allEmployers[0]
                                                let secondEmployer = allEmployers[1]
                                                self.checkEmployer(firstEmployer)
                                                secondEmployer.integer = 2
                                                expectation.fulfill()
                })
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testNoPrimaryForClassWithSubclass() {
        let classWithNoPrimaryWithSubClass = ClassWithNoPrimaryWithSubClass()
        classWithNoPrimaryWithSubClass.fillData()
        classWithNoPrimaryWithSubClass.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithNoPrimaryWithSubClass.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testNoPrimaryForClassWithSubclassArray() {
        let classWithNoPrimaryWithSubClassArray = ClassWithNoPrimaryWithSubClassArray()
        classWithNoPrimaryWithSubClassArray.fillData()
        classWithNoPrimaryWithSubClassArray.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithNoPrimaryWithSubClassArray.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testNoPrimaryForClassWithImage() {
        let classWithNoPrimaryWithImage = ClassWithNoPrimaryWithImage()
        classWithNoPrimaryWithImage.fillData()
        classWithNoPrimaryWithImage.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithNoPrimaryWithImage.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testNoPrimaryForClassWithImageArray() {
        ClassWithNoPrimaryWithImageArray.delete()
        let classWithNoPrimaryWithImageArray = ClassWithNoPrimaryWithImageArray()
        classWithNoPrimaryWithImageArray.fillData()
        classWithNoPrimaryWithImageArray.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ClassWithNoPrimaryWithImageArray.retrieve(completion: { (results) in
                XCTAssertEqual(results.count, 1)
                XCTAssert(results.first?.images == nil)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testNoPrimaryForClassWithPrimitiveArray() {
        let classWithNoPrimaryWithPrimitiveArray = ClassWithNoPrimaryWithPrimitiveArray()
        classWithNoPrimaryWithPrimitiveArray.fillData()
        classWithNoPrimaryWithPrimitiveArray.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithNoPrimaryWithPrimitiveArray.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testNoPrimaryForClassWithDate() {
        let classWithNoPrimaryWithDate = ClassWithNoPrimaryWithDate()
        classWithNoPrimaryWithDate.fillData()
        classWithNoPrimaryWithDate.save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ClassWithNoPrimaryWithDate.retrieve(completion: { (results) in
                XCTAssert(results.isEmpty)
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testArraySaving() {
        guard let employer = employer else {
            XCTFail("Employer is nil")
            return
        }
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string1"
        employer2.integer = 2
        [employer2,employer].save()
        let expectation = XCTestExpectation(description: "Retrieve Employer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            EmployerForTesting.retrieve(completion: { (allEmployers) in
                guard let employer1 = allEmployers.first else {
                    XCTFail("Couldn't Retrieve From Database")
                    return
                }
                self.checkEmployer(allEmployers[1])
                XCTAssert(employer1.integer == 2)
                XCTAssert(employer1.string == "string1")
                expectation.fulfill()
            })
        }
        wait(for: [expectation], timeout: 5)
        
    }
    
    
    
    
    func testUpdateWithNoChanges() {
        do {
            try EmployerForTesting.update()
        } catch {
            guard let sundeedError = error as? SundeedQLiteError else {
                XCTFail("Wrong Error")
                return
            }
            XCTAssert(sundeedError.description == SundeedQLiteError.noChangesMade(tableName: "EmployerForTesting").description)
        }
    }
    
    private func checkEmployer(_ employer: EmployerForTesting) {
        XCTAssertEqual(employer.type, .manager)
        XCTAssertEqual(employer.mandatoryType, .ceo)
        XCTAssertEqual(employer.arrayOfTypes, [.manager, .ceo])
        XCTAssertEqual(employer.optionalArrayOfTypes, [.manager, .ceo])
        XCTAssertEqual(employer.optionalArrayOfOptionalTypes, [.manager, .ceo])
        XCTAssertEqual(employer.arrayOfOptionalTypes, [.manager, .ceo])
        XCTAssertEqual(employer.string, "string")
        XCTAssertEqual(employer.optionalString, "optionalString")
        XCTAssertNotNil(employer.object)
        XCTAssertNotNil(employer.optionalObject)
        XCTAssertEqual(employer.integer, 1)
        XCTAssertEqual(employer.optionalInteger, 2)
        XCTAssertEqual(employer.double, 3.0)
        XCTAssertEqual(employer.optionalDouble, 4.0)
        XCTAssertEqual(employer.float, 5.0)
        XCTAssertEqual(employer.optionalFloat, 6.0)
        XCTAssertEqual(employer.bool, true)
        XCTAssertEqual(employer.optionalBool, true)
        XCTAssertNotNil(employer.date)
        XCTAssertNotNil(employer.optionalDate)
        XCTAssertEqual(employer.image.jpegData(compressionQuality: 1),
                       UIImage(named: "image")?.jpegData(compressionQuality: 1))
        XCTAssertEqual(employer.optionalImage?.jpegData(compressionQuality: 1),
                       UIImage(named: "image")?.jpegData(compressionQuality: 1))
        XCTAssertEqual(employer.arrayOfStrings, ["string1", "string2"])
        XCTAssertEqual(employer.arrayOfOptionalStrings, ["string3"])
        XCTAssertEqual(employer.optionalArrayOfStrings, ["string4", "string6"])
        XCTAssertEqual(employer.optionalArrayOfOptionalStrings, ["string7"])
        XCTAssertNotNil(employer.arrayOfObjects)
        XCTAssertFalse(employer.arrayOfObjects.isEmpty)
        XCTAssertNotNil(employer.arrayOfOptionalObjects)
        XCTAssertNotNil(employer.optionalArrayOfObjects)
        XCTAssertNotNil(employer.optionalArrayOfOptionalObjects)
        XCTAssertEqual(employer.arrayOfIntegers[0], 1)
        XCTAssertEqual(employer.arrayOfIntegers[1], 2)
        XCTAssertEqual(employer.arrayOfOptionalIntegers[0], 2)
        XCTAssertEqual(employer.optionalArrayOfIntegers?[0], 1)
        XCTAssertEqual(employer.optionalArrayOfIntegers?[1], 2)
        XCTAssertEqual(employer.optionalArrayOfOptionalIntegers?[0], 2)
        XCTAssertEqual(employer.arrayOfDoubles[0], 3.0)
        XCTAssertEqual(employer.arrayOfDoubles[1], 4.0)
        XCTAssertEqual(employer.arrayOfOptionalDoubles[0], 4.0)
        XCTAssertEqual(employer.optionalArrayOfDoubles?[0], 3.0)
        XCTAssertEqual(employer.optionalArrayOfDoubles?[1], 4.0)
        XCTAssertEqual(employer.optionalArrayOfOptionalDoubles?[0], 4.0)
        XCTAssertEqual(employer.arrayOfFloats[0], 5.0)
        XCTAssertEqual(employer.arrayOfFloats[1], 6.0)
        XCTAssertEqual(employer.arrayOfOptionalFloats[0], 6.0)
        XCTAssertEqual(employer.optionalArrayOfFloats?[0], 5.0)
        XCTAssertEqual(employer.optionalArrayOfFloats?[1], 6.0)
        XCTAssertEqual(employer.optionalArrayOfOptionalFloats?[0], 6.0)
        XCTAssertTrue(employer.arrayOfBools[0])
        XCTAssertFalse(employer.arrayOfBools[1])
        XCTAssertTrue(employer.arrayOfOptionalBools[0] ?? false)
        XCTAssertTrue(employer.optionalArrayOfBools?[0] ?? false)
        XCTAssertFalse(employer.optionalArrayOfBools?[1] ?? true)
        XCTAssertTrue(employer.optionalArrayOfOptionalBools?[0] ?? false)
        XCTAssertNotNil(employer.arrayOfDates)
        XCTAssertNotNil(employer.arrayOfOptionalDates)
        XCTAssertNotNil(employer.optionalArrayOfDates)
        XCTAssertNotNil(employer.optionalArrayOfOptionalDates)
        XCTAssertNotNil(employer.arrayOfImages)
        XCTAssertEqual(employer.arrayOfImages.first?.jpegData(compressionQuality: 1),
                       UIImage(named: "image")?.jpegData(compressionQuality: 1))
        XCTAssertNotNil(employer.arrayOfOptionalImages)
        XCTAssertEqual(employer.arrayOfOptionalImages
            .first??.jpegData(compressionQuality: 1),
                       UIImage(named: "image")?.jpegData(compressionQuality: 1))
        XCTAssertNotNil(employer.optionalArrayOfImages)
        XCTAssertNotNil(employer.optionalArrayOfOptionalImages)
        XCTAssertNil(employer.nilString)
        XCTAssertNil(employer.nilObject)
        XCTAssertNil(employer.nilInteger)
        XCTAssertNil(employer.nilDouble)
        XCTAssertNil(employer.nilFloat)
        XCTAssertNil(employer.nilBool)
        XCTAssertNil(employer.nilDate)
        XCTAssertNil(employer.nilImage)
        XCTAssertNil(employer.nilArrayOfStrings)
        XCTAssertNil(employer.nilArrayOfOptionalStrings)
        XCTAssertNil(employer.nilArrayOfObjects)
        XCTAssertNil(employer.nilArrayOfOptionalObjects)
        XCTAssertNil(employer.nilArrayOfDoubles)
        XCTAssertNil(employer.nilArrayOfOptionalDoubles)
        XCTAssertNil(employer.nilArrayOfFloats)
        XCTAssertNil(employer.nilArrayOfOptionalFloats)
        XCTAssertNil(employer.nilArrayOfBools)
        XCTAssertNil(employer.nilArrayOfOptionalBools)
        XCTAssertNil(employer.nilArrayOfDates)
        XCTAssertNil(employer.nilArrayOfOptionalDates)
        XCTAssertNil(employer.nilArrayOfImages)
        XCTAssertNil(employer.nilArrayOfOptionalImages)
        XCTAssertEqual(employer.emptyArrayOfStrings.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalStrings.count, 0)
        XCTAssertEqual(employer.emptyArrayOfObjects.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalObjects.count, 0)
        XCTAssertEqual(employer.emptyArrayOfDoubles.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalDoubles.count, 0)
        XCTAssertEqual(employer.emptyArrayOfFloats.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalFloats.count, 0)
        XCTAssertEqual(employer.emptyArrayOfBools.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalBools.count, 0)
        XCTAssertEqual(employer.emptyArrayOfDates.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalDates.count, 0)
        XCTAssertEqual(employer.emptyArrayOfImages.count, 0)
        XCTAssertEqual(employer.emptyArrayOfOptionalImages.count, 0)
    }
}
