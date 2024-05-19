//
//  ArrayMandatoryTestWithNil.swift
//  SundeedQLiteLibraryTests
//
//  Created by Nour Sandid on 5/19/20.
//  Copyright © 2020 LUMBERCODE. All rights reserved.
//

import XCTest
import SundeedQLiteLibrary

class ArrayMandatoryTestWithNil: XCTestCase {
    override func tearDown(completion: @escaping ((any Error)?) -> Void) {
        Task {
            await ClassContainingAMandatoryOptionalArrayWithNil.delete()
            await ClassContainingAMandatoryArrayWithNil.delete()
            await ClassContainingAMandatoryArrayWithOptionalNil.delete()
            await ClassContainingAMandatoryOptionalArrayWithOptionalNil.delete()
            completion(nil)
        }
    }
    
    func testClassContainingAMandatoryOptionalArrayWithNil() async {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithNil()
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithNil.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryArrayWithNil() async {
        let mainClass = ClassContainingAMandatoryArrayWithNil()
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithNil.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalNil() async {
        let mainClass = ClassContainingAMandatoryArrayWithOptionalNil()
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithOptionalNil.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalNil() async {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalNil()
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithOptionalNil.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithNilSubObject() async {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithNil()
        let mandatoryClass = MandatoryClass()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithNil.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryArrayWithNilSubObject() async {
        let mainClass = ClassContainingAMandatoryArrayWithNil()
        let mandatoryClass = MandatoryClass()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithNil.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryArrayWithOptionalNilSubObject() async {
        let mainClass = ClassContainingAMandatoryArrayWithOptionalNil()
        let mandatoryClass = MandatoryClass()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryArrayWithOptionalNil.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
    
    func testClassContainingAMandatoryOptionalArrayWithOptionalNilSubObject() async {
        let mainClass = ClassContainingAMandatoryOptionalArrayWithOptionalNil()
        let mandatoryClass = MandatoryClass()
        mainClass.mandatoryClasses = [mandatoryClass]
        
        await mainClass.save()
        let retrievedClasses = await ClassContainingAMandatoryOptionalArrayWithOptionalNil.retrieve()
        XCTAssertEqual(retrievedClasses.count, 0)
    }
}
