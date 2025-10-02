//
//  RetrieveWithFilter.swift
//  SundeedQLiteLibrary
//
//  Created by Nour Sandid on 02/10/2025.
//  Copyright © 2025 LUMBERCODE. All rights reserved.
//

import XCTest
import SundeedQLiteLibrary

class RetrieveWithFilter: XCTestCase {
    var employer: EmployerForTesting? = EmployerForTesting()
    
    override func setUp() {
        employer?.fillData()
    }
    override func tearDown() async throws {
        await EmployerForTesting.delete()
        await EmployeeForTesting.delete()
    }
    
    func testRetrieveWithFilter() async {
        
        await employer?.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "string")
        guard let employer = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employer.check()
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithDateFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("date") == employer.date)
        guard let employer = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employer.check()
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithGreaterThanDateFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.date = employer.date.addingTimeInterval(-100000)
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.date = employer.date.addingTimeInterval(100000)
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("date") > employer.date)
        guard let employer2ToBeFetched = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(employer2ToBeFetched.string, employer2.string)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithGreaterThanOrEqualDateFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.date = employer.date.addingTimeInterval(-100)
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.date = employer.date.addingTimeInterval(100)
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("date") >= employer.date)
        XCTAssertEqual(allEmployers.count, 2)
        guard let employerToBeFetched = allEmployers.first, let employer2ToBeFetched = allEmployers.last else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employerToBeFetched.check()
        XCTAssertEqual(employerToBeFetched.string, employer.string)
        XCTAssertEqual(employer2ToBeFetched.string, employer2.string)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithLessThanDateFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.date = employer.date.addingTimeInterval(-100)
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.date = employer.date.addingTimeInterval(100)
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("date") < employer.date)
        guard let employer1ToBeFetched = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(employer1ToBeFetched.string, employer1.string)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithLessOrEqualThanDateFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.date = employer.date.addingTimeInterval(-100)
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.date = employer.date.addingTimeInterval(100)
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("date") < employer.date)
        guard let employer1ToBeFetched = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(employer1ToBeFetched.string, employer1.string)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithLessThanOrEqualDateFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.date = employer.date.addingTimeInterval(-100)
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.date = employer.date.addingTimeInterval(100)
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("date") <= employer.date)
        XCTAssertEqual(allEmployers.count, 2)
        guard let employerToBeFetched = allEmployers.first, let employer1ToBeFetched = allEmployers.last else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employerToBeFetched.check()
        XCTAssertEqual(employer1ToBeFetched.string, employer1.string)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithIntFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("integer") == employer.integer)
        guard let employer = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employer.check()
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithGreaterThanIntFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.integer = employer.integer - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.integer = employer.integer + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("integer") > employer.integer)
        guard let employer2ToBeFetched = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(employer2ToBeFetched.integer, employer2.integer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithGreaterThanOrEqualIntegerFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.integer = employer.integer - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.integer = employer.integer + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("integer") >= employer.integer)
        XCTAssertEqual(allEmployers.count, 2)
        guard let employer2ToBeFetched = allEmployers.first, let employerToBeFetched = allEmployers.last else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employerToBeFetched.check()
        XCTAssertEqual(employerToBeFetched.integer, employer.integer)
        XCTAssertEqual(employer2ToBeFetched.integer, employer2.integer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithLessThanIntegerFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.integer = employer.integer - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.integer = employer.integer + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("integer") < employer.integer)
        guard let employer1ToBeFetched = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(employer1ToBeFetched.integer, employer1.integer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithLessOrEqualThanIntegerFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.integer = employer.integer - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.integer = employer.integer + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("integer") < employer.integer)
        guard let employer1ToBeFetched = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(employer1ToBeFetched.integer, employer1.integer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithLessThanOrEqualIntegerFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.integer = employer.integer - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.integer = employer.integer + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("integer") <= employer.integer)
        XCTAssertEqual(allEmployers.count, 2)
        guard let employerToBeFetched = allEmployers.first, let employer1ToBeFetched = allEmployers.last else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employerToBeFetched.check()
        XCTAssertEqual(employer1ToBeFetched.integer, employer1.integer)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithDoubleFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("double") == employer.double)
        guard let employer = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employer.check()
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithGreaterThanDoubleFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.double = employer.double - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.double = employer.double + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("double") > employer.double)
        guard let employer2ToBeFetched = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(employer2ToBeFetched.double, employer2.double)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithGreaterThanOrEqualDoubleFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.double = employer.double - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.double = employer.double + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("double") >= employer.double)
        XCTAssertEqual(allEmployers.count, 2)
        guard let employerToBeFetched = allEmployers.first, let employer2ToBeFetched = allEmployers.last else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employerToBeFetched.check()
        XCTAssertEqual(employerToBeFetched.double, employer.double)
        XCTAssertEqual(employer2ToBeFetched.double, employer2.double)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithLessThanDoubleFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.double = employer.double - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.double = employer.double + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("double") < employer.double)
        guard let employer1ToBeFetched = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(employer1ToBeFetched.double, employer1.double)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithLessOrEqualThanDoubleFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.double = employer.double - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.double = employer.double + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("double") < employer.double)
        guard let employer1ToBeFetched = allEmployers.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(employer1ToBeFetched.double, employer1.double)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithLessThanOrEqualDoubleFilter() async {
        guard let employer else { XCTFail("Employer is nil"); return }
        await employer.save()
        let employer1 = EmployerForTesting()
        employer1.string = "employer1"
        employer1.double = employer.double - 1
        await employer1.save()
        let employer2 = EmployerForTesting()
        employer2.string = "employer2"
        employer2.double = employer.double + 1
        await employer2.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("double") <= employer.double)
        XCTAssertEqual(allEmployers.count, 2)
        guard let employerToBeFetched = allEmployers.first, let employer1ToBeFetched = allEmployers.last else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        employerToBeFetched.check()
        XCTAssertEqual(employer1ToBeFetched.double, employer1.double)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
        _ = try? await employer1.delete(deleteSubObjects: true)
        _ = try? await employer2.delete(deleteSubObjects: true)
    }
    
    func testRetrieveWithWrongFilter() async {
        
        await employer?.save()
        let allEmployers = await EmployerForTesting.retrieve(withFilter: SundeedColumn("string") == "ABCD")
        XCTAssertEqual(allEmployers.count, 0)
        _ = try? await self.employer?.delete(deleteSubObjects: true)
    }
}
