//
//  ImagePrimaryKeyErrorTests.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 7/8/26.
//  Copyright © 2026 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class ClassWithNilPrimaryAndImages: @unchecked Sendable, SundeedQLiter {
    var id: String?
    var image: UIImage?
    var images: [UIImage?]?
    var data: Data?
    required init() {}

    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        image <~> map["image"]
        images <~> map["images"]
        data <~> map["data"]
    }
}

class ClassWithPrimaryAndData: @unchecked Sendable, SundeedQLiter {
    var id: String = "dataUpdate1"
    var data: Data?
    required init() {}

    func sundeedQLiterMapping(map: SundeedQLiteMap) {
        id <~> map["id"]+
        data <~> map["data"]
    }
}

class ImagePrimaryKeyErrorTests: XCTestCase {

    override func tearDown() {
        SundeedQLite.deleteDatabase()
    }

    private func assertGlobalUpdateThrows(changes: SundeedUpdateSetStatement,
                                          file: StaticString = #filePath,
                                          line: UInt = #line) async {
        do {
            try await ClassWithNilPrimaryAndImages.update(changes: changes)
            XCTFail("It shouldn't be able to update without a primary key value",
                    file: file, line: line)
        } catch {
            XCTAssertTrue(error is SundeedQLiteError, file: file, line: line)
        }
    }

    func testGlobalUpdateImageWithNilPrimaryKeyValue() async {
        await assertGlobalUpdateThrows(
            changes: SundeedUpdateSetStatement(sundeedColumn: SundeedColumn("image"),
                                               withValue: UIImage()))
    }

    func testGlobalUpdateImageArrayWithNilPrimaryKeyValue() async {
        await assertGlobalUpdateThrows(
            changes: SundeedUpdateSetStatement(sundeedColumn: SundeedColumn("images"),
                                               withValue: [UIImage()] as AnyObject))
    }

    func testGlobalUpdateDataWithNilPrimaryKeyValue() async {
        await assertGlobalUpdateThrows(
            changes: SundeedUpdateSetStatement(sundeedColumn: SundeedColumn("data"),
                                               withValue: "Test Data".data(using: .utf8)! as AnyObject))
    }

    func testGlobalUpdateObjectWithNilPrimaryKeyValue() async {
        let employee = EmployeeForTesting(id: "E1", seniorID: "E2", juniorID: "E3")
        await assertGlobalUpdateThrows(
            changes: SundeedUpdateSetStatement(sundeedColumn: SundeedColumn("object"),
                                               withValue: employee.toObjectWrapper()))
    }

    func testGlobalUpdateObjectArrayWithNilPrimaryKeyValue() async {
        let employee = EmployeeForTesting(id: "E1", seniorID: "E2", juniorID: "E3")
        await assertGlobalUpdateThrows(
            changes: SundeedUpdateSetStatement(sundeedColumn: SundeedColumn("objects"),
                                               withValue: [employee.toObjectWrapper()] as AnyObject))
    }

    func testGlobalUpdatePrimitiveArrayWithNilPrimaryKeyValue() async {
        await assertGlobalUpdateThrows(
            changes: SundeedUpdateSetStatement(sundeedColumn: SundeedColumn("strings"),
                                               withValue: ["a", "b"] as AnyObject))
    }

    func testGlobalUpdateDataWithPrimaryKeyValue() async {
        let object = ClassWithPrimaryAndData()
        object.data = "Test Data".data(using: .utf8)
        await object.save()
        do {
            let newData = "Updated Data".data(using: .utf8)! as AnyObject
            try await ClassWithPrimaryAndData.update(
                changes: SundeedUpdateSetStatement(sundeedColumn: SundeedColumn("data"),
                                                   withValue: newData))
            let retrieved = await ClassWithPrimaryAndData.retrieve()
            XCTAssertEqual(retrieved.first?.data, "Updated Data".data(using: .utf8))
        } catch {
            XCTFail("It should be able to update a data attribute: \(error)")
        }
    }

    func testSaveDataWithNilPrimaryKeyValue() async {
        let object = ClassWithNilPrimaryAndImages()
        object.data = "Test Data".data(using: .utf8)
        await object.save()
        let retrieved = await ClassWithNilPrimaryAndImages.retrieve()
        XCTAssertTrue(retrieved.isEmpty,
                      "Saving a data attribute without a primary key value should fail")
    }

    func testSaveImageArrayWithoutTypesDefaultsToTextType() async {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }
        let wrapper = ObjectWrapper(tableName: "NoTypesImageArrayTable",
                                    className: "NoTypesImageArrayTable",
                                    objects: [Sundeed.shared.primaryKey: "TestID",
                                              "id": "TestID",
                                              "images": [image],
                                              "strings": ["a", "b"]],
                                    types: nil,
                                    hasPrimaryKey: true)
        await Processors().saveProcessor.save(objects: [wrapper])
        guard let imageDirectory = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("SundeedQLite/Image", isDirectory: true) else {
            XCTFail("Cannot access document directory")
            return
        }
        let imagePath = imageDirectory.appendingPathComponent("TestIDimages0.png").path
        XCTAssertTrue(FileManager.default.fileExists(atPath: imagePath),
                      "Image should be saved even when the wrapper has no types")
    }

    func testSaveObjectArrayWithoutClassNameAddsNil() async {
        let objectWithoutClassName = ObjectWrapper(tableName: "NoClassNameTable",
                                                   className: nil,
                                                   objects: ["field": "value"],
                                                   types: nil)
        let wrapper = ObjectWrapper(tableName: "ObjectArrayWithoutClassNameTable",
                                    className: "ObjectArrayWithoutClassNameTable",
                                    objects: [Sundeed.shared.primaryKey: "TestID2",
                                              "id": "TestID2",
                                              "objects": [objectWithoutClassName] as [ObjectWrapper?]],
                                    types: nil,
                                    hasPrimaryKey: true)
        await Processors().saveProcessor.save(objects: [wrapper])
        XCTAssertTrue(Sundeed.shared.tables.contains("ObjectArrayWithoutClassNameTable"))
    }
}
