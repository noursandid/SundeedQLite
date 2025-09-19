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
        employer?.fillData()
    }
    override func tearDown(completion: @escaping ((any Error)?) -> Void) {
        Task {
            await EmployerForTesting.delete()
            await EmployeeForTesting.delete()
            SundeedQLite.deleteDatabase()
            completion(nil)
        }
    }
    
    func testDeleting() async {
        
        await employer?.save()
        do {
            try await self.employer?.delete()
            let allEmployers = await EmployerForTesting.retrieve()
            XCTAssert(allEmployers.isEmpty)
            let allEmployees = await EmployeeForTesting.retrieve()
            XCTAssertEqual(allEmployees.count, 6)
        } catch {
            XCTFail("Couldn't delete class")
        }
    }
    
    func testDeletingWithoutDeletingSubObjects() async {
        await employer?.save()
        do {
            try await self.employer?.delete(deleteSubObjects: false)
            let allEmployers = await EmployerForTesting.retrieve()
            XCTAssert(allEmployers.isEmpty)
            let allEmployees = await EmployeeForTesting.retrieve()
            XCTAssertEqual(allEmployees.count, 6)
        } catch {
            XCTFail("Couldn't delete class")
        }
    }
    
    func testDeletingWithDeletingSubObjects() async {
        
        await employer?.save()
        do {
            try await self.employer?.delete(deleteSubObjects: true)
            let allEmployers = await EmployerForTesting.retrieve()
            XCTAssertTrue(allEmployers.isEmpty)
            let allEmployees = await EmployeeForTesting.retrieve()
            XCTAssertEqual(allEmployees.count, 0)
            let allSeniorEmployees = await SeniorEmployeeForTesting.retrieve()
            XCTAssertEqual(allSeniorEmployees.count, 0)
            let allJuniorEmployees = await JuniorEmployeeForTesting.retrieve()
            XCTAssertEqual(allJuniorEmployees.count, 0)
        } catch {
            XCTFail("Couldn't delete class")
            
        }
    }
    
    func testDeletingAll() async {
        await employer?.save()
        await EmployerForTesting.delete()
        let allEmployers = await EmployerForTesting.retrieve()
        XCTAssert(allEmployers.isEmpty)
        let allEmployees = await EmployeeForTesting.retrieve()
        XCTAssertEqual(allEmployees.count, 6)
    }
    
    func testRetrieve() async {
        
        await employer?.save()
        let allEmployers = await EmployerForTesting.retrieve()
        guard let employer = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        self.checkEmployer(employer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithFilter() async {
        
        await employer?.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "string")
        guard let employer = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        self.checkEmployer(employer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    
    func testRetrieveWithWrongFilter() async {
        
        await employer?.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "ABCD")
        XCTAssertEqual(allEmployers.count, 0)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithSortingIntAsc() async {
        
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "str"
        employer2.integer = 2
        await [employer!, employer2].save()
        let allEmployers = await EmployerForTesting.retrieve(orderBy: SundeedColumn("integer"),
                                                             ascending: true)
        XCTAssertEqual(allEmployers.count, 2)
        let firstEmployer = allEmployers[0]
        let secondEmployer = allEmployers[1]
        self.checkEmployer(firstEmployer)
        XCTAssertEqual(secondEmployer.integer, 2)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithSortingIntDesc() async {
        
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "stri"
        employer2.integer = 3
        await [employer!, employer2].save()
        let allEmployers = await EmployerForTesting.retrieve(orderBy: SundeedColumn("integer"),
                                                             ascending: false)
        XCTAssertEqual(allEmployers.count, 2)
        let firstEmployer = allEmployers[0]
        let secondEmployer = allEmployers[1]
        XCTAssertEqual(firstEmployer.integer, 3)
        self.checkEmployer(secondEmployer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
        
    }
    
    func testRetrieveWithSortingStringAsc() async {
        
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string2"
        employer2.integer = 2
        await [employer!, employer2].save()
        let allEmployers = await EmployerForTesting.retrieve(orderBy: SundeedColumn("string"),
                                                             ascending: true)
        XCTAssertEqual(allEmployers.count, 2)
        let firstEmployer = allEmployers[0]
        let secondEmployer = allEmployers[1]
        self.checkEmployer(firstEmployer)
        XCTAssertEqual(secondEmployer.integer, 2)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithSortingStringDesc() async {
        
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string3"
        employer2.integer = 3
        await [employer!, employer2].save()
        let allEmployers = await EmployerForTesting
            .retrieve(orderBy: SundeedColumn("string"),
                      ascending: false)
        XCTAssertEqual(allEmployers.count, 2)
        guard allEmployers.count == 2 else {
            XCTFail()
            return
        }
        let firstEmployer = allEmployers[0]
        let secondEmployer = allEmployers[1]
        XCTAssertEqual(firstEmployer.integer, 3)
        self.checkEmployer(secondEmployer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithSortingDateAsc() async {
        
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string2"
        employer2.integer = 2
        employer2.date = Date().addingTimeInterval(500)
        await [employer!, employer2].save()
        let allEmployers = await EmployerForTesting.retrieve(orderBy: SundeedColumn("date"),
                                                             ascending: true)
        XCTAssertEqual(allEmployers.count, 2)
        let firstEmployer = allEmployers[0]
        let secondEmployer = allEmployers[1]
        self.checkEmployer(firstEmployer)
        XCTAssertEqual(secondEmployer.integer, 2)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithSortingDateDesc() async {
        
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string3"
        employer2.integer = 3
        employer2.date = Date().addingTimeInterval(500)
        await [employer!, employer2].save()
        let allEmployers = await EmployerForTesting.retrieve(orderBy: SundeedColumn("date"),
                                                             ascending: false)
        XCTAssertEqual(allEmployers.count, 2)
        let firstEmployer = allEmployers[0]
        let secondEmployer = allEmployers[1]
        XCTAssertEqual(firstEmployer.integer, 3)
        self.checkEmployer(secondEmployer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
        
    }
    
    func testRetrieveWithSortingEnumAsc() async {
        
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string2"
        employer2.integer = 2
        employer2.type = .ceo
        await [employer!, employer2].save()
        let allEmployers = await EmployerForTesting.retrieve(orderBy: SundeedColumn("type"),
                                                             ascending: true)
        XCTAssertEqual(allEmployers.count, 2)
        let firstEmployer = allEmployers[0]
        let secondEmployer = allEmployers[1]
        self.checkEmployer(firstEmployer)
        XCTAssertEqual(secondEmployer.integer, 2)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
        
    }
    
    func testRetrieveWithSortingEnumDesc() async {
        
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string3"
        employer2.integer = 3
        employer2.type = .ceo
        await [employer!, employer2].save()
        let allEmployers = await EmployerForTesting.retrieve(orderBy: SundeedColumn("type"),
                                                             ascending: false)
        XCTAssertEqual(allEmployers.count, 2)
        let firstEmployer = allEmployers[0]
        let secondEmployer = allEmployers[1]
        self.checkEmployer(firstEmployer)
        XCTAssertEqual(secondEmployer.integer, 3)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveForeignObjectWithExcludingIfIsForeignDisabled() async {
        
        let employees = await EmployeeForTesting.retrieve(excludeIfIsForeign: false)
        XCTAssertEqual(employees.count, 0)
        await [employer!].save()
        let allEmployees = await EmployeeForTesting.retrieve(excludeIfIsForeign: false)
        XCTAssertEqual(allEmployees.count, 6)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testRetrieveForeignObjectWithExcludingIfIsForeignEnabled() async {
        
        await [employer!].save()
        let allEmployees = await EmployeeForTesting.retrieve(excludeIfIsForeign: true)
        XCTAssertEqual(allEmployees.count, 0)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testRetrieveIndependentObjectWithExcludingIfIsForeignDisabled() async {
        
        await [employer!].save()
        let allEmployers = await EmployerForTesting.retrieve(excludeIfIsForeign: false)
        XCTAssertEqual(allEmployers.count, 1)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testRetrieveIndependentObjectWithExcludingIfIsForeignEnabled() async {
        
        await [self.employer!].save()
        let allEmployers = await EmployerForTesting.retrieve(excludeIfIsForeign: true)
        XCTAssertEqual(allEmployers.count, 1)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testNoPrimaryForClassWithSubclass() async {
        let classWithNoPrimaryWithSubClass = ClassWithNoPrimaryWithSubClass()
        classWithNoPrimaryWithSubClass.fillData()
        
        await classWithNoPrimaryWithSubClass.save()
        let results = await ClassWithNoPrimaryWithSubClass.retrieve()
        XCTAssert(results.isEmpty)
        let _ = try? await classWithNoPrimaryWithSubClass.delete(deleteSubObjects: true)
        
    }
    
    func testNoPrimaryForClassWithSubclassArray() async {
        let classWithNoPrimaryWithSubClassArray = ClassWithNoPrimaryWithSubClassArray()
        classWithNoPrimaryWithSubClassArray.fillData()
        
        await classWithNoPrimaryWithSubClassArray.save()
        let results = await ClassWithNoPrimaryWithSubClassArray.retrieve()
        XCTAssert(results.isEmpty)
        let _ = try? await classWithNoPrimaryWithSubClassArray.delete(deleteSubObjects: true)
    }
    
    func testNoPrimaryForClassWithImage() async {
        let classWithNoPrimaryWithImage = ClassWithNoPrimaryWithImage()
        classWithNoPrimaryWithImage.fillData()
        
        await classWithNoPrimaryWithImage.save()
        let results = await ClassWithNoPrimaryWithImage.retrieve()
        XCTAssert(results.isEmpty)
        let _ = try? await classWithNoPrimaryWithImage.delete(deleteSubObjects: true)
    }
    
    func testNoPrimaryForClassWithImageArray() async {
        
        await ClassWithNoPrimaryWithImageArray.delete()
        let classWithNoPrimaryWithImageArray = ClassWithNoPrimaryWithImageArray()
        classWithNoPrimaryWithImageArray.fillData()
        await classWithNoPrimaryWithImageArray.save()
        let results = await ClassWithNoPrimaryWithImageArray.retrieve()
        XCTAssertEqual(results.count, 1)
        XCTAssertNil(results.first?.images)
        let _ = try? await classWithNoPrimaryWithImageArray.delete(deleteSubObjects: true)
        
    }
    
    func testNoPrimaryForClassWithPrimitiveArray() async {
        let classWithNoPrimaryWithPrimitiveArray = ClassWithNoPrimaryWithPrimitiveArray()
        classWithNoPrimaryWithPrimitiveArray.fillData()
        
        await classWithNoPrimaryWithPrimitiveArray.save()
        let results = await ClassWithNoPrimaryWithPrimitiveArray.retrieve()
        XCTAssert(results.isEmpty)
        let _ = try? await classWithNoPrimaryWithPrimitiveArray.delete(deleteSubObjects: true)
    }
    
    func testNoPrimaryForClassWithDate() async {
        let classWithNoPrimaryWithDate = ClassWithNoPrimaryWithDate()
        classWithNoPrimaryWithDate.fillData()
        
        await classWithNoPrimaryWithDate.save()
        let results = await ClassWithNoPrimaryWithDate.retrieve()
        XCTAssert(results.isEmpty)
        let _ = try? await classWithNoPrimaryWithDate.delete(deleteSubObjects: true)
    }
    
    func testArraySaving() async {
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string1"
        employer2.integer = 2
        
        await [employer2, employer!].save()
        let allEmployers = await EmployerForTesting.retrieve()
        guard let employer1 = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        self.checkEmployer(allEmployers[1])
        XCTAssertEqual(employer1.integer, 2)
        XCTAssertEqual(employer1.string, "string1")
        let _ = try? await self.employer?.delete(deleteSubObjects: true)
        let _ = try? await employer2.delete(deleteSubObjects: true)
        
    }
    
    func testUpdateWithNoChanges() async {
        do {
            try await EmployerForTesting.update()
        } catch {
            guard let sundeedError = error as? SundeedQLiteError else {
                XCTFail("Wrong Error")
                return
            }
            XCTAssertEqual(sundeedError.description, SundeedQLiteError.noChangesMade(tableName: "EmployerForTesting").description)
        }
    }
    
    private func checkEmployer(_ employer: EmployerForTesting) {
        XCTAssertEqual(employer.type, .manager)
        XCTAssertEqual(employer.data, "Testing Data".data(using: .utf8))
        XCTAssertEqual(employer.mandatoryData, "Testing Mandatory Data".data(using: .utf8) ?? Data())
        XCTAssertEqual(employer.optionalData, "Testing Optional Data".data(using: .utf8))
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
        XCTAssertEqual(employer.image.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "1")?.jpegData(compressionQuality: 1)?.description)
        XCTAssertEqual(employer.optionalImage?.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "2")?.jpegData(compressionQuality: 1)?.description)
        XCTAssertEqual(employer.arrayOfStrings, ["string1", "string2"])
        XCTAssertEqual(employer.arrayOfOptionalStrings, ["string3"])
        XCTAssertEqual(employer.optionalArrayOfStrings, ["string4", "string6"])
        XCTAssertEqual(employer.optionalArrayOfOptionalStrings, ["string7"])
        XCTAssertEqual(employer.arrayOfData, ["Testing Array Of Data".data(using: .utf8)!])
        XCTAssertEqual(employer.arrayOfOptionalData, ["Testing Array Of Optional Data".data(using: .utf8)])
        XCTAssertEqual(employer.optionalArrayOfData, ["Testing Optional Array Of Data".data(using: .utf8)!])
        XCTAssertEqual(employer.optionalArrayOfOptionalData, ["Testing Optional Array Of Optional Data".data(using: .utf8)])
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
        XCTAssertEqual(employer.arrayOfImages.first?.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "3")?.jpegData(compressionQuality: 1)?.description)
        XCTAssertNotNil(employer.arrayOfOptionalImages)
        
        XCTAssertEqual(employer.arrayOfOptionalImages
            .first??.jpegData(compressionQuality: 1)?.description,
                       UIImage(named: "5")?.jpegData(compressionQuality: 1)?.description)
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
