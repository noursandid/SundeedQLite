//
//  RetrieveWithSorting.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 02/10/2025.
//  Copyright © 2025 LUMBERCODE. All rights reserved.
//
import XCTest
import SundeedQLiteLibrary

class RetrieveWithSorting: XCTestCase {
    var employer: EmployerForTesting? = EmployerForTesting()
    
    override func setUp() {
        employer?.fillData()
    }
    override func tearDown() async throws {
        await EmployerForTesting.delete()
        await EmployeeForTesting.delete()
    }
    func testRetrieveWithSortingIntAsc() async {
        let employee1 = EmployeeForTesting(id: "employee1", seniorID: "senior1", juniorID: "junior1")
        employee1.integer = 1
        employee1.firstName = "employee1"
        await employee1.save()
        let employee2 = EmployeeForTesting(id: "employee2", seniorID: "senior2", juniorID: "junior2")
        employee1.id = "employee2"
        employee2.integer = 2
        employee1.firstName = "employee2"
        await employee2.save()
        let allEmployees = await EmployeeForTesting.retrieve()
        XCTAssertEqual(allEmployees.count, 2)
        let firstEmployee = allEmployees[0]
        let secondEmployee = allEmployees[1]
        XCTAssertEqual(firstEmployee.integer, 1)
        XCTAssertEqual(secondEmployee.integer, 2)
        _ = try? await employee1.delete(deleteSubObjects: true)
        _ = try? await employee2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithSortingIntDesc() async {
        
        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "stri"
        employer2.integer = 3
        await [employer!, employer2].save()
        let allEmployers = await EmployerForTesting.retrieve()
        XCTAssertEqual(allEmployers.count, 2)
        let firstEmployer = allEmployers[0]
        let secondEmployer = allEmployers[1]
        XCTAssertEqual(firstEmployer.integer, 3)
        secondEmployer.check()
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
        firstEmployer.check()
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
        secondEmployer.check()
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
        firstEmployer.check()
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
        secondEmployer.check()
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
        secondEmployer.check()
        XCTAssertEqual(firstEmployer.integer, 2)
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
        firstEmployer.check()
        XCTAssertEqual(secondEmployer.integer, 3)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
}
