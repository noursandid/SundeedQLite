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

    override func tearDown() async throws {
        await EmployerForTesting.delete()
        await EmployeeForTesting.delete()
        await SeniorEmployeeForTesting.delete()
        await JuniorEmployeeForTesting.delete()
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
        employer.check()
        _ = try? await self.employer?.delete(deleteSubObjects: true)
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
        allEmployers[1].check()
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
}
