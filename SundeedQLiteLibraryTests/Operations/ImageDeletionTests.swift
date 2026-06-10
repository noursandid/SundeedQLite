//
//  ImageDeletionTests.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 4/11/26.
//  Copyright © 2026 LUMBERCODE. All rights reserved.
//

import XCTest
@testable import SundeedQLiteLibrary

class ImageDeletionTests: XCTestCase {
    var employer: EmployerForTesting = EmployerForTesting()

    private var imageDirectoryURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("SundeedQLite/Image", isDirectory: true)
    }

    private func imageFileCount() -> Int {
        guard let imageDir = imageDirectoryURL else { return 0 }
        return (try? FileManager.default.contentsOfDirectory(atPath: imageDir.path))?.count ?? 0
    }

    override func setUp() async throws {
        employer.fillData()
    }

    override func tearDown() async throws {
        SundeedQLite.deleteDatabase()
        SundeedQLiteMap.clearReferences()
    }

    // MARK: - Basic Image File Lifecycle

    func testSavingObjectCreatesImageFiles() async {
        await employer.save()
        guard let imageDir = imageDirectoryURL else {
            XCTFail("Cannot access document directory")
            return
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: imageDir.path),
                       "Image directory should exist after saving an object with images")
        let files = try? FileManager.default.contentsOfDirectory(atPath: imageDir.path)
        XCTAssertNotNil(files)
        XCTAssertFalse(files?.isEmpty ?? true,
                        "Image directory should contain image files")
    }

    func testSavedImageFilesArePNG() async {
        await employer.save()
        guard let imageDir = imageDirectoryURL else {
            XCTFail("Cannot access document directory")
            return
        }
        let files = (try? FileManager.default.contentsOfDirectory(atPath: imageDir.path)) ?? []
        for file in files {
            XCTAssertTrue(file.hasSuffix(".png"),
                           "Image file '\(file)' should have .png extension")
        }
    }

    func testImageFileCountMatchesSavedImages() async {
        await employer.save()
        // EmployerForTesting.fillData() sets:
        // image (1), optionalImage (1), arrayOfImages (2), arrayOfOptionalImages (1 non-nil),
        // optionalArrayOfImages (2), optionalArrayOfOptionalImages (1 non-nil)
        // Total: 8 image files
        let count = imageFileCount()
        XCTAssertEqual(count, 8,
                        "Expected 8 image files, got \(count)")
    }

    // MARK: - deleteDatabase Image Cleanup

    func testDeleteDatabaseRemovesImageDirectory() async {
        await employer.save()
        guard let imageDir = imageDirectoryURL else {
            XCTFail("Cannot access document directory")
            return
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: imageDir.path),
                       "Image directory should exist before deleteDatabase")
        SundeedQLite.deleteDatabase()
        XCTAssertFalse(FileManager.default.fileExists(atPath: imageDir.path),
                        "Image directory should be removed after deleteDatabase")
    }

    func testDeleteDatabaseRemovesImageFiles() async {
        await employer.save()
        guard let imageDir = imageDirectoryURL else {
            XCTFail("Cannot access document directory")
            return
        }
        let filesBefore = try? FileManager.default.contentsOfDirectory(atPath: imageDir.path)
        XCTAssertFalse(filesBefore?.isEmpty ?? true,
                        "Image files should exist before deleteDatabase")
        SundeedQLite.deleteDatabase()
        let dirExists = FileManager.default.fileExists(atPath: imageDir.path)
        if dirExists {
            let filesAfter = try? FileManager.default.contentsOfDirectory(atPath: imageDir.path)
            XCTAssertTrue(filesAfter?.isEmpty ?? true,
                           "Image files should be removed after deleteDatabase")
        }
    }

    func testDeleteDatabaseOnEmptyDatabaseDoesNotCrash() {
        SundeedQLite.deleteDatabase()
        guard let imageDir = imageDirectoryURL else {
            XCTFail("Cannot access document directory")
            return
        }
        XCTAssertFalse(FileManager.default.fileExists(atPath: imageDir.path),
                        "Image directory should not exist when no images were saved")
    }

    func testDeleteDatabaseCalledTwiceDoesNotCrash() async {
        await employer.save()
        SundeedQLite.deleteDatabase()
        SundeedQLite.deleteDatabase()
        guard let imageDir = imageDirectoryURL else {
            XCTFail("Cannot access document directory")
            return
        }
        XCTAssertFalse(FileManager.default.fileExists(atPath: imageDir.path))
    }

    // MARK: - Individual Object Deletion

    func testDeleteObjectDoesNotRemoveImageFiles() async {
        await employer.save()
        let filesBefore = imageFileCount()
        XCTAssertGreaterThan(filesBefore, 0,
                              "Image files should exist before deleting object")
        do {
            try await employer.delete(deleteSubObjects: true)
        } catch {
            XCTFail("Delete should not throw: \(error)")
        }
        let filesAfter = imageFileCount()
        XCTAssertEqual(filesBefore, filesAfter,
                        "Image files should still exist after deleting individual object")
    }

    func testDeleteAllDoesNotRemoveImageFiles() async {
        await employer.save()
        let filesBefore = imageFileCount()
        XCTAssertGreaterThan(filesBefore, 0)
        await EmployerForTesting.delete()
        let filesAfter = imageFileCount()
        XCTAssertEqual(filesBefore, filesAfter,
                        "Image files should still exist after deleteAll")
    }

    // MARK: - Save/Retrieve Cycle with Images

    func testSaveRetrieveDeleteRetrieveImagesCleared() async {
        await employer.save()
        let retrieved1 = await EmployerForTesting.retrieve()
        XCTAssertEqual(retrieved1.count, 1)
        XCTAssertNotNil(retrieved1.first?.image)
        XCTAssertNotNil(retrieved1.first?.optionalImage)

        SundeedQLite.deleteDatabase()

        let retrieved2 = await EmployerForTesting.retrieve()
        XCTAssertTrue(retrieved2.isEmpty,
                       "No employers should be retrievable after deleteDatabase")
    }

    func testMultipleSaveDeleteCyclesCleanupImages() async {
        await employer.save()
        SundeedQLite.deleteDatabase()
        SundeedQLiteMap.clearReferences()

        guard let imageDir = imageDirectoryURL else {
            XCTFail("Cannot access document directory")
            return
        }
        XCTAssertFalse(FileManager.default.fileExists(atPath: imageDir.path),
                        "Image directory should be removed after first deleteDatabase")

        let employer2 = EmployerForTesting()
        employer2.fillData()
        await employer2.save()
        XCTAssertTrue(FileManager.default.fileExists(atPath: imageDir.path),
                       "Image directory should be recreated after saving again")

        SundeedQLite.deleteDatabase()
        XCTAssertFalse(FileManager.default.fileExists(atPath: imageDir.path),
                        "Image directory should be removed after second deleteDatabase")
    }

    // MARK: - Image Overwrite on Re-save

    func testResavingObjectOverwritesImageFiles() async {
        await employer.save()
        let countAfterFirstSave = imageFileCount()
        XCTAssertGreaterThan(countAfterFirstSave, 0)

        // Save same object again — should overwrite, not duplicate
        await employer.save()
        let countAfterSecondSave = imageFileCount()
        XCTAssertEqual(countAfterFirstSave, countAfterSecondSave,
                        "Re-saving should overwrite existing images, not create duplicates")
    }

    // MARK: - Update with Image Changes

    func testUpdateImageColumnCreatesNewFile() async {
        await employer.save()
        let countBefore = imageFileCount()

        // Update nilImage (was nil, now set)
        employer.nilImage = UIImage(named: "3")!
        do {
            try await employer.update(columns: SundeedColumn("nilImage"))
        } catch {
            XCTFail("Update should not throw: \(error)")
        }

        let countAfter = imageFileCount()
        XCTAssertGreaterThan(countAfter, countBefore,
                              "Updating a nil image to a value should create a new image file")
    }

    func testUpdateImageArrayAddsFiles() async {
        await employer.save()
        let countBefore = imageFileCount()

        employer.arrayOfImages.append(UIImage(named: "5")!)
        do {
            try await employer.update(columns: SundeedColumn("arrayOfImages"))
        } catch {
            XCTFail("Update should not throw: \(error)")
        }

        let countAfter = imageFileCount()
        XCTAssertGreaterThan(countAfter, countBefore,
                              "Appending to an image array and updating should create additional files")
    }

    // MARK: - Image Retrieval After Save

    func testRetrievedImageMatchesSavedImage() async {
        await employer.save()
        let retrieved = await EmployerForTesting.retrieve()
        guard let retrievedEmployer = retrieved.first else {
            XCTFail("Could not retrieve employer")
            return
        }
        XCTAssertEqual(
            retrievedEmployer.image.jpegData(compressionQuality: 1)?.description,
            UIImage(named: "1")?.jpegData(compressionQuality: 1)?.description,
            "Retrieved image should match the saved image"
        )
    }

    func testRetrievedOptionalImageMatchesSavedImage() async {
        await employer.save()
        let retrieved = await EmployerForTesting.retrieve()
        guard let retrievedEmployer = retrieved.first else {
            XCTFail("Could not retrieve employer")
            return
        }
        XCTAssertEqual(
            retrievedEmployer.optionalImage?.jpegData(compressionQuality: 1)?.description,
            UIImage(named: "2")?.jpegData(compressionQuality: 1)?.description,
            "Retrieved optional image should match the saved image"
        )
    }

    func testRetrievedNilImageIsNil() async {
        await employer.save()
        let retrieved = await EmployerForTesting.retrieve()
        guard let retrievedEmployer = retrieved.first else {
            XCTFail("Could not retrieve employer")
            return
        }
        XCTAssertNil(retrievedEmployer.nilImage,
                      "Image that was nil at save time should be nil after retrieval")
    }

    func testRetrievedImageArrayMatchesSaved() async {
        await employer.save()
        let retrieved = await EmployerForTesting.retrieve()
        guard let retrievedEmployer = retrieved.first else {
            XCTFail("Could not retrieve employer")
            return
        }
        XCTAssertEqual(retrievedEmployer.arrayOfImages.count, 2,
                        "Retrieved image array should have same count as saved")
        XCTAssertEqual(
            retrievedEmployer.arrayOfImages.first?.jpegData(compressionQuality: 1)?.description,
            UIImage(named: "3")?.jpegData(compressionQuality: 1)?.description
        )
    }

    func testRetrievedNilImageArrayIsNil() async {
        await employer.save()
        let retrieved = await EmployerForTesting.retrieve()
        guard let retrievedEmployer = retrieved.first else {
            XCTFail("Could not retrieve employer")
            return
        }
        XCTAssertNil(retrievedEmployer.nilArrayOfImages,
                      "Nil image array should remain nil after retrieval")
        XCTAssertNil(retrievedEmployer.nilArrayOfOptionalImages,
                      "Nil optional image array should remain nil after retrieval")
    }

    // MARK: - Image Retrieval After deleteDatabase

    func testImageRetrievalReturnsNilAfterDeletingFiles() async {
        await employer.save()

        // Manually remove the image directory to simulate file loss
        if let imageDir = imageDirectoryURL {
            try? FileManager.default.removeItem(at: imageDir)
        }

        let retrieved = await EmployerForTesting.retrieve()
        guard let retrievedEmployer = retrieved.first else {
            XCTFail("Could not retrieve employer")
            return
        }
        // The DB record still exists but the image file is gone,
        // so fromDatatypeValue returns nil and the non-optional image
        // stays at its default initializer value
        XCTAssertNotNil(retrievedEmployer.image,
                         "Non-optional image falls back to default init value")
        // Optional image should be nil since file is missing
        XCTAssertNil(retrievedEmployer.optionalImage,
                      "Optional image should be nil when image file is missing")
    }

    // MARK: - Two Different Objects with Images

    func testTwoObjectsCreateSeparateImageFiles() async {
        await employer.save()
        let countAfterFirst = imageFileCount()

        let employer2 = EmployerForTesting()
        employer2.fillData()
        employer2.string = "string2"
        await employer2.save()
        let countAfterSecond = imageFileCount()

        XCTAssertGreaterThan(countAfterSecond, countAfterFirst,
                              "Saving a second object with images should create additional image files")

        SundeedQLite.deleteDatabase()
        XCTAssertEqual(imageFileCount(), 0,
                        "deleteDatabase should remove all image files from both objects")
    }
}
