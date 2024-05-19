//
//  OperationTestsWithoutPrimaryKey.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/16/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
import SundeedQLiteLibrary

class OperationTestsWithoutPrimaryKey: XCTestCase {
    var noPrimary: ClassWithNoPrimary?
    var employerWithNoPrimary: EmployerWithNoPrimaryForTesting?
    
    
    override func setUp() {
        employerWithNoPrimary = EmployerWithNoPrimaryForTesting()
        employerWithNoPrimary?.fillData()
        noPrimary = ClassWithNoPrimary()
        noPrimary?.fillData()
    }
    override func tearDown(completion: @escaping ((any Error)?) -> Void) {
        Task {
            await EmployerWithNoPrimaryForTesting.delete()
            await ClassWithNoPrimary.delete()
            noPrimary = nil
            employerWithNoPrimary = nil
            completion(nil)
        }
    }
    
    func testSaveEmployerWithNoPrimary() async {
        await employerWithNoPrimary?.save()
        let employers = await EmployerWithNoPrimaryForTesting.retrieve()
        XCTAssert(employers.isEmpty)
    }
    
    
    func testRetrieve() async {
        
        await noPrimary?.save()
        let noPrimaries = await ClassWithNoPrimary.retrieve()
        guard let noPrimary = noPrimaries.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(noPrimary.firstName, "TestFirst")
        XCTAssertEqual(noPrimary.lastName, "TestLast")
    }
    
    func testRetrieveWithFilter() async {
        
        await noPrimary?.save()
            let noPrimaries = await ClassWithNoPrimary.retrieve(withFilter: SundeedColumn("firstName") == "TestFirst")
        
        guard let noPrimary = noPrimaries.first else {
            XCTFail("Couldn't Retrieve From Database")
            return
        }
        XCTAssertEqual(noPrimary.firstName, "TestFirst")
        XCTAssertEqual(noPrimary.lastName, "TestLast")
    }
    
    func testUpdate() async {
        await noPrimary?.save()
        do {
            self.noPrimary?.firstName = "TestFirstUpdated"
            try await self.noPrimary?.update(columns: SundeedColumn("firstName"))
            XCTFail("It shouldn't be able to update")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testGlobalUpdate() async {
        
        await noPrimary?.save()
        do {
            try await ClassWithNoPrimary.update(changes: SundeedColumn("firstName") <~ "TestFirstUpdated")
            XCTFail("It shouldn't be able to update")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
}
