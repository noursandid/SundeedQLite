//
//  ThreadSafetyTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class ThreadSafetyTests: XCTestCase {

    override func tearDown(completion: @escaping ((any Error)?) -> Void) {
        SundeedQLite.deleteDatabase()
        SundeedQLiteMap.clearReferences()
        completion(nil)
    }

    // MARK: - Listener thread safety
    func testConcurrentListenerAddAndRemove() {
        let expectation = expectation(description: "concurrent listeners")
        let iterations = 100
        let group = DispatchGroup()

        for i in 0..<iterations {
            group.enter()
            DispatchQueue.global().async {
                let listener = SundeedQLite.addListener(
                    object: EmployeeForTesting.self,
                    function: { (_: EmployeeForTesting) in },
                    operation: .save
                )
                // Remove some listeners to test concurrent removal
                if i % 2 == 0 {
                    listener.stop()
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testConcurrentSpecificListenerAddAndRemove() {
        let expectation = expectation(description: "concurrent specific listeners")
        let iterations = 50
        let group = DispatchGroup()

        for i in 0..<iterations {
            group.enter()
            DispatchQueue.global().async {
                let employee = EmployeeForTesting()
                employee.id = "EMP_\(i)"
                let listener = SundeedQLite.addSpecificListener(
                    object: employee,
                    function: { (_: EmployeeForTesting) in },
                    operation: .any
                )
                if i % 3 == 0 {
                    listener.stop()
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    // MARK: - Reference cache thread safety
    func testConcurrentReferenceAddAndGet() {
        let expectation = expectation(description: "concurrent references")
        let iterations = 100
        let group = DispatchGroup()

        for i in 0..<iterations {
            group.enter()
            DispatchQueue.global().async {
                let employee = EmployeeForTesting()
                employee.id = "EMP_\(i)"
                SundeedQLiteMap.addReference(
                    object: employee,
                    andValue: "EMP_\(i)" as AnyObject,
                    andClassName: "EmployeeForTesting"
                )
                let _ = SundeedQLiteMap.getReference(
                    andValue: "EMP_\(i)" as AnyObject,
                    andClassName: "EmployeeForTesting"
                )
                group.leave()
            }
        }

        group.notify(queue: .main) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testClearReferences() {
        let employee = EmployeeForTesting()
        employee.id = "EMP_CLEAR"
        SundeedQLiteMap.addReference(
            object: employee,
            andValue: "EMP_CLEAR" as AnyObject,
            andClassName: "TestClear"
        )
        XCTAssertNotNil(SundeedQLiteMap.getReference(
            andValue: "EMP_CLEAR" as AnyObject,
            andClassName: "TestClear"
        ))

        SundeedQLiteMap.clearReferences()

        XCTAssertNil(SundeedQLiteMap.getReference(
            andValue: "EMP_CLEAR" as AnyObject,
            andClassName: "TestClear"
        ))
    }

    // MARK: - Concurrent save and retrieve
    func testConcurrentSaveAndRetrieve() async {
        let employee = EmployeeForTesting()
        employee.id = "CONCURRENT_1"
        employee.firstName = "John"
        await employee.save()

        // Run multiple retrieves concurrently
        await withTaskGroup(of: [EmployeeForTesting].self) { group in
            for _ in 0..<10 {
                group.addTask {
                    await EmployeeForTesting.retrieve()
                }
            }
            for await results in group {
                XCTAssertFalse(results.isEmpty)
            }
        }
    }
}
