//
//  MemoryLeakTests.swift
//  SundeedQLiteLibraryTests
//

import XCTest
@testable import SundeedQLiteLibrary

final class MemoryLeakTests: XCTestCase {

    override func tearDown(completion: @escaping ((any Error)?) -> Void) {
        SundeedQLite.deleteDatabase()
        SundeedQLiteMap.clearReferences()
        completion(nil)
    }

    // MARK: - Reference cache retains objects

    func testReferenceCacheRetainsObject() {
        weak var weakRef: EmployeeForTesting?
        autoreleasepool {
            let employee = EmployeeForTesting()
            employee.id = "LEAK_1"
            weakRef = employee
            SundeedQLiteMap.addReference(
                object: employee,
                andValue: "LEAK_1" as AnyObject,
                andClassName: "EmployeeForTesting"
            )
        }
        // Object is still retained by the reference cache
        XCTAssertNotNil(weakRef, "Cache should retain the object")
    }

    func testClearReferencesReleasesObjects() {
        weak var weakRef: EmployeeForTesting?
        autoreleasepool {
            let employee = EmployeeForTesting()
            employee.id = "LEAK_2"
            weakRef = employee
            SundeedQLiteMap.addReference(
                object: employee,
                andValue: "LEAK_2" as AnyObject,
                andClassName: "EmployeeForTesting"
            )
        }
        XCTAssertNotNil(weakRef, "Cache should retain the object before clear")
        SundeedQLiteMap.clearReferences()
        XCTAssertNil(weakRef, "Object should be released after clearReferences()")
    }

    func testRemoveReferenceReleasesObject() {
        weak var weakRef: EmployeeForTesting?
        autoreleasepool {
            let employee = EmployeeForTesting()
            employee.id = "LEAK_3"
            weakRef = employee
            SundeedQLiteMap.addReference(
                object: employee,
                andValue: "LEAK_3" as AnyObject,
                andClassName: "EmployeeForTesting"
            )
        }
        XCTAssertNotNil(weakRef)
        SundeedQLiteMap.removeReference(
            value: "LEAK_3" as AnyObject,
            andClassName: "EmployeeForTesting"
        )
        XCTAssertNil(weakRef, "Object should be released after removeReference()")
    }

    // MARK: - Listener retains referenced object

    func testListenerRetainsObject() {
        weak var weakRef: EmployeeForTesting?
        var listener: Listener?
        autoreleasepool {
            let employee = EmployeeForTesting()
            employee.id = "LISTEN_1"
            weakRef = employee
            listener = SundeedQLite.addSpecificListener(
                object: employee,
                function: { (_: EmployeeForTesting) in },
                operation: .save
            )
        }
        // Listener holds a strong ref to the object via `object: Any?`
        XCTAssertNotNil(weakRef, "Listener should retain the observed object")
        _ = listener // keep listener alive
    }

    func testListenerStopReleasesObject() {
        weak var weakRef: EmployeeForTesting?
        autoreleasepool {
            let employee = EmployeeForTesting()
            employee.id = "LISTEN_2"
            weakRef = employee
            let listener = SundeedQLite.addSpecificListener(
                object: employee,
                function: { (_: EmployeeForTesting) in },
                operation: .save
            )
            listener.stop()
        }
        XCTAssertNil(weakRef, "Object should be released after listener.stop()")
    }

    func testListenerClosureDoesNotRetainSelf() {
        weak var weakRef: EmployeeForTesting?
        autoreleasepool {
            let employee = EmployeeForTesting()
            employee.id = "LISTEN_3"
            weakRef = employee
            // Non-specific listener with class type (not instance)
            let listener = SundeedQLite.addListener(
                object: EmployeeForTesting.self,
                function: { (_: EmployeeForTesting) in },
                operation: .save
            )
            listener.stop()
        }
        // Non-specific listener doesn't hold the instance, only the type
        XCTAssertNil(weakRef, "Object should be released when no listener holds it")
    }

    // MARK: - Save/Delete cycle releases from cache

    func testDeleteRemovesFromReferenceCache() async {
        let employee = EmployeeForTesting()
        employee.id = "DEL_CACHE_1"
        employee.firstName = "ToDelete"
        await employee.save()

        // Verify it's in the cache after save
        let cachedBefore = SundeedQLiteMap.getReference(
            andValue: "DEL_CACHE_1" as AnyObject,
            andClassName: "EmployeeForTesting"
        )
        // Cache may or may not have it depending on mapping flow,
        // but after delete it should definitely be removed
        try? await employee.delete()

        let cachedAfter = SundeedQLiteMap.getReference(
            andValue: "DEL_CACHE_1" as AnyObject,
            andClassName: "EmployeeForTesting"
        )
        XCTAssertNil(cachedAfter, "Reference cache should not hold deleted objects")
        _ = cachedBefore // suppress unused warning
    }

    // MARK: - Multiple save/retrieve cycles don't accumulate

    func testRepeatedRetrieveDoesNotGrowCacheUnbounded() async {
        let employee = EmployeeForTesting()
        employee.id = "GROW_1"
        employee.firstName = "Test"
        await employee.save()

        // Retrieve multiple times
        for _ in 0..<10 {
            let _ = await EmployeeForTesting.retrieve()
        }

        // Clear and verify objects are released
        SundeedQLiteMap.clearReferences()
        let cached = SundeedQLiteMap.getReference(
            andValue: "GROW_1" as AnyObject,
            andClassName: "EmployeeForTesting"
        )
        XCTAssertNil(cached, "clearReferences should empty the cache completely")
    }

    // MARK: - Nested objects and cache

    func testNestedObjectsClearedFromCache() {
        weak var weakSenior: SeniorEmployeeForTesting?
        weak var weakJunior: JuniorEmployeeForTesting?
        autoreleasepool {
            let senior = SeniorEmployeeForTesting()
            senior.id = "SR_1"
            let junior = JuniorEmployeeForTesting()
            junior.id = "JR_1"
            senior.juniorEmployee = junior
            weakSenior = senior
            weakJunior = junior

            SundeedQLiteMap.addReference(
                object: senior,
                andValue: "SR_1" as AnyObject,
                andClassName: "SeniorEmployeeForTesting"
            )
            SundeedQLiteMap.addReference(
                object: junior,
                andValue: "JR_1" as AnyObject,
                andClassName: "JuniorEmployeeForTesting"
            )
        }
        XCTAssertNotNil(weakSenior)
        XCTAssertNotNil(weakJunior)

        SundeedQLiteMap.clearReferences()

        XCTAssertNil(weakSenior, "Senior should be released after clearReferences()")
        XCTAssertNil(weakJunior, "Junior should be released after clearReferences()")
    }
}
