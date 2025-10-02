//
//  ArrayMandatoryTestWithData.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
import SundeedQLiteLibrary

class ArrayMandatoryTestWithData: XCTestCase {
    override func tearDown(completion: @escaping ((any Error)?) -> Void) {
        Task {
            await MandatoryClass.delete()
            await ClassContainingAMandatoryClassInOptionalArray.delete()
            await ClassContainingAMandatoryOptionalClassInArray.delete()
            await ClassContainingAMandatoryOptionalClassInOptionalArray.delete()
            await ClassContainingAMandatoryClassInArray.delete()
            await ClassContainingAMandatoryClass.delete()
            await ClassContainingAMandatoryOptionalClass.delete()
            await ClassContainingAMandatoryArrayWithData.delete()
            await ClassContainingAMandatoryOptionalArrayWithOptionalData.delete()
            await ClassContainingAMandatoryArrayWithOptionalData.delete()
            await ClassContainingParameterIndex.delete()
            await ClassContainingAMandatoryOptionalArrayWithData.delete()
            completion(nil)
        }
    }
    
    func testClassContainingAMandatoryClassInOptionalArray() async {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryClassInOptionalArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryClassInOptionalArray.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryOptionalClassInArray() async {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryOptionalClassInArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalClassInArray.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryOptionalClassInOptionalArray() async {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryOptionalClassInOptionalArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalClassInOptionalArray.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryClassInArray() async {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryClassInArray()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryClassInArray.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryClass() async {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryClass()
        mainClass.mandatoryClasses = mandatoryClass
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryClass.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryOptionalClass() async {
        let mandatoryClass = MandatoryClass()
        let mainClass = ClassContainingAMandatoryOptionalClass()
        mainClass.mandatoryClasses = mandatoryClass
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalClass.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryArrayWithData() async {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryArrayWithData()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithData
            .retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithData() async {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryOptionalArrayWithData()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithData.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalData() async {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalData()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithOptionalData.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalData() async {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryArrayWithOptionalData()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithOptionalData
            .retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
    }
    
    func testClassContainingAMandatoryArrayWithDataWithReference() async {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryArrayWithData()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithData
            .retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithDataWithReference() async {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryOptionalArrayWithData()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithData.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalDataWithReference() async {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalData()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithOptionalData.retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalDataWithReference() async {
        let mandatoryClass = MandatoryClass()
        mandatoryClass.firstName = "Test"
        let mainClass = ClassContainingAMandatoryArrayWithOptionalData()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithOptionalData
            .retrieve()
        XCTAssertEqual(retrievedClasses.count, 1)
    }
    
    func testClassContainingParameterIndex() async {
        let mainClass = ClassContainingParameterIndex()
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingParameterIndex.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
}
