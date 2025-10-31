//
//  RetrieveWithLimitAndSkip.swift
//  SundeedQLiteLibrary
//
//  Created by Tests on 10/31/2025.
//

import XCTest
import SundeedQLiteLibrary

class RetrieveWithLimitAndSkip: XCTestCase {
    var employer1: EmployerForTesting = EmployerForTesting()
    var employer2: EmployerForTesting = EmployerForTesting()
    var employer3: EmployerForTesting = EmployerForTesting()
    
    override func setUp() {
        employer1.fillData()
        employer1.integer = 1
        employer1.string = "emp1"
        
        employer2.fillData()
        employer2.integer = 2
        employer2.string = "emp2"
        
        employer3.fillData()
        employer3.integer = 3
        employer3.string = "emp3"
    }
    
    override func tearDown() async throws {
        await EmployerForTesting.delete()
        await EmployeeForTesting.delete()
    }
    
    func testRetrieveWithLimitOnly() async {
        await [employer1, employer2, employer3].save()
        let results = await EmployerForTesting.retrieve(withFilter: nil,
                                                        orderBy: SundeedColumn("integer"),
                                                        ascending: true,
                                                        limit: 1)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.string, "emp1")
    }
    
    func testRetrieveWithSkipOnly() async {
        await [employer1, employer2, employer3].save()
        let results = await EmployerForTesting.retrieve(orderBy: SundeedColumn("integer"),
                                                        ascending: true,
                                                        skip: 1)
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results.first?.string, "emp2")
    }
    
    func testRetrieveWithSkipAndLimitOrdered() async {
        await [employer1, employer2, employer3].save()
        let results = await EmployerForTesting.retrieve(withFilter: nil,
                                                        orderBy: SundeedColumn("integer"),
                                                        ascending: true,
                                                        limit: 2,
                                                        skip: 1)
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].string, "emp2")
        XCTAssertEqual(results[1].string, "emp3")
    }
}


