//
//  BugFixIntegrationTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class BugFixIntegrationTests: XCTestCase {

    override func tearDown() async throws {
        await EmployerForTesting.delete()
        await EmployeeForTesting.delete()
        SundeedQLiteMap.clearReferences()
    }

    // MARK: - Float < vs <= end-to-end (Bug 1)

    func testFloatLessThanExcludesEqualValue() async {
        let emp1 = EmployerForTesting()
        emp1.string = "low"
        emp1.float = 5.0
        emp1.integer = 1
        await emp1.save()

        let emp2 = EmployerForTesting()
        emp2.string = "exact"
        emp2.float = 10.0
        emp2.integer = 2
        await emp2.save()

        let emp3 = EmployerForTesting()
        emp3.string = "high"
        emp3.float = 15.0
        emp3.integer = 3
        await emp3.save()

        // < 10.0 should return only "low" (not "exact")
        let lessThan = await EmployerForTesting.retrieve(
            withFilter: SundeedColumn("float") < 10.0 as Float
        )
        XCTAssertEqual(lessThan.count, 1)
        XCTAssertEqual(lessThan.first?.string, "low")

        // <= 10.0 should return "low" and "exact"
        let lessOrEqual = await EmployerForTesting.retrieve(
            withFilter: SundeedColumn("float") <= 10.0 as Float
        )
        XCTAssertEqual(lessOrEqual.count, 2)
    }

    func testFloatLessThanWithNegativeValues() async {
        let emp1 = EmployerForTesting()
        emp1.string = "negative"
        emp1.float = -5.5
        emp1.integer = 1
        await emp1.save()

        let emp2 = EmployerForTesting()
        emp2.string = "zero"
        emp2.float = 0.0
        emp2.integer = 2
        await emp2.save()

        let results = await EmployerForTesting.retrieve(
            withFilter: SundeedColumn("float") < 0.0 as Float
        )
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.string, "negative")
    }

    // MARK: - Listener callbacks fire correctly (Bug 3)

    func testListenerReceivesSaveCallback() async {
        let expectation = expectation(description: "save listener")
        var receivedName: String?

        let listener = SundeedQLite.addListener(
            object: EmployeeForTesting.self,
            function: { (emp: EmployeeForTesting) in
                receivedName = emp.firstName
                expectation.fulfill()
            },
            operation: .save
        )

        let employee = EmployeeForTesting()
        employee.id = "LISTEN_SAVE_1"
        employee.firstName = "CallbackTest"
        await employee.save()

        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertEqual(receivedName, "CallbackTest")
        listener.stop()
    }

    func testListenerDoesNotFireAfterStop() async {
        var callCount = 0

        let listener = SundeedQLite.addListener(
            object: EmployeeForTesting.self,
            function: { (_: EmployeeForTesting) in
                callCount += 1
            },
            operation: .save
        )

        let emp1 = EmployeeForTesting()
        emp1.id = "STOP_1"
        await emp1.save()

        // Small delay to let callback fire
        try? await Task.sleep(nanoseconds: 200_000_000)
        let countAfterFirst = callCount

        listener.stop()

        let emp2 = EmployeeForTesting()
        emp2.id = "STOP_2"
        await emp2.save()

        try? await Task.sleep(nanoseconds: 200_000_000)
        XCTAssertEqual(callCount, countAfterFirst, "Listener should not fire after stop()")
    }

    func testSpecificListenerOnlyFiresForMatchingObject() async {
        let target = EmployeeForTesting()
        target.id = "SPECIFIC_TARGET"

        var targetCallCount = 0

        let listener = SundeedQLite.addSpecificListener(
            object: target,
            function: { (_: EmployeeForTesting) in
                targetCallCount += 1
            },
            operation: .save
        )

        // Save the target
        target.firstName = "Target"
        await target.save()

        // Save a different object
        let other = EmployeeForTesting()
        other.id = "SPECIFIC_OTHER"
        other.firstName = "Other"
        await other.save()

        try? await Task.sleep(nanoseconds: 200_000_000)
        XCTAssertEqual(targetCallCount, 1, "Specific listener should only fire for matching object")
        listener.stop()
    }

    // MARK: - needsSeparator produces correct SQL (Bug 5)

    func testMultiColumnInsertHasCorrectCommas() {
        let statement = InsertStatement(with: "TestTable")
            .add(key: "col1", value: "val1")
            .add(key: "col2", value: "val2")
            .add(key: "col3", value: "val3")
        let result = statement.build()
        XCTAssertNotNil(result)
        // Should have 2 commas between 3 columns, not trailing comma
        let query = result!.query
        XCTAssertFalse(query.contains(", )"), "Should not have trailing comma before )")
        XCTAssertFalse(query.contains(",)"), "Should not have trailing comma before )")
    }

    func testMultiFilterDeleteHasCorrectAND() {
        let filter1 = SundeedColumn("a") == "1"
        let filter2 = SundeedColumn("b") == "2"
        let filter3 = SundeedColumn("c") == "3"
        let statement = DeleteStatement(with: "TestTable")
            .withFilters([filter1, filter2, filter3])
        let result = statement.build()
        XCTAssertNotNil(result)
        let query = result!
        // Count AND occurrences - should be exactly 2 for 3 filters
        let andCount = query.components(separatedBy: " AND ").count - 1
        XCTAssertEqual(andCount, 2, "3 filters should produce exactly 2 ANDs")
    }

    func testSingleFilterNoTrailingAND() {
        let filter = SundeedColumn("x") == "1"
        let statement = DeleteStatement(with: "TestTable")
            .withFilters([filter])
        let result = statement.build()
        XCTAssertNotNil(result)
        XCTAssertFalse(result!.contains(" AND "), "Single filter should have no AND")
    }

    func testSingleColumnInsertNoTrailingComma() {
        let statement = InsertStatement(with: "TestTable")
            .add(key: "only_col", value: "val")
        let result = statement.build()
        XCTAssertNotNil(result)
        let query = result!.query
        XCTAssertFalse(query.contains(", "), "Single column INSERT should have no comma")
    }

    // MARK: - Save/retrieve cycle with reference cache (Bug 4)

    func testRetrievedObjectsAreIndependent() async {
        let emp = EmployeeForTesting()
        emp.id = "INDEP_1"
        emp.firstName = "Original"
        await emp.save()

        let results1 = await EmployeeForTesting.retrieve(
            withFilter: SundeedColumn("id") == "INDEP_1"
        )
        let results2 = await EmployeeForTesting.retrieve(
            withFilter: SundeedColumn("id") == "INDEP_1"
        )

        XCTAssertEqual(results1.first?.firstName, "Original")
        XCTAssertEqual(results2.first?.firstName, "Original")

        // Mutating one shouldn't affect the other
        results1.first?.firstName = "Modified"
        XCTAssertEqual(results2.first?.firstName, "Original",
                       "Retrieved objects should be independent instances")
    }

    // MARK: - defer finalization (Bug 6) - retrieve with empty table

    func testRetrieveFromNonExistentTableReturnsEmpty() async {
        // This exercises the early-return path in RetrieveProcessor
        // where defer must still close the connection
        let results = await EmployeeForTesting.retrieve(
            withFilter: SundeedColumn("id") == "DOES_NOT_EXIST"
        )
        XCTAssertEqual(results.count, 0)
    }

    func testRepeatedRetrieveDoesNotLeakConnections() async {
        let emp = EmployeeForTesting()
        emp.id = "CONN_LEAK"
        emp.firstName = "Test"
        await emp.save()

        // Rapidly retrieve many times — if connections leak, this would
        // exhaust file descriptors or deadlock
        for _ in 0..<50 {
            let _ = await EmployeeForTesting.retrieve()
        }

        // If we get here without hanging, connections are properly closed
        let final_results = await EmployeeForTesting.retrieve(
            withFilter: SundeedColumn("id") == "CONN_LEAK"
        )
        XCTAssertEqual(final_results.count, 1)
    }
}
